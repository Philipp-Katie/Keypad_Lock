#include <xc.inc>

global  LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_delay_x4us, LCD_delay_ms, LCD_Clear
    
psect	udata_acs   
LCD_cnt_l:	ds 1	
LCD_cnt_h:	ds 1	
LCD_cnt_ms:	ds 1	
LCD_tmp:	ds 1	
LCD_counter:	ds 1	

PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
LCD_hex_tmp:	ds 1    

	LCD_E	EQU 5	
    	LCD_RS	EQU 4	

psect	lcd_code,class=CODE
    
LCD_Setup:
	clrf    LATB, A
	movlw   11000000B	; RB0:5 all outputs
	movwf	TRISB, A
	movlw   40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	00110000B	; Function set 4-bit
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00101000B	; 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00101000B	; repeat, 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00001111B	; display on, cursor on, blinking on
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00000001B	; display clear
	call	LCD_Send_Byte_I
	movlw	2		; wait 2ms
	call	LCD_delay_ms
	movlw	00000110B	; entry mode incr by 1 no shift
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	return
	
LCD_Clear:
	movlw	00000001B	;Clears the LCD Display
	call	LCD_Send_Byte_I
	movlw	0x02
	call	LCD_delay_ms
	return

LCD_Write_Hex:			; Writes byte stored in W as hex
	movwf	LCD_hex_tmp, A
	swapf	LCD_hex_tmp, W, A	
	movf	LCD_hex_tmp, W, A	
LCD_Hex_Nib:			
	andlw	0x0F
	movwf	LCD_tmp, A
	movlw	0x0A
	cpfslt	LCD_tmp, A
	addlw	0x07		
	addlw	0x26
	addwf	LCD_tmp, W, A
	call	LCD_Send_Byte_D 
	return	
	
LCD_Write_Message:		 ; Message stored at FSR2, length stored in W
	movwf   LCD_counter, A
LCD_Loop_message:
	movf    POSTINC2, W, A
	call    LCD_Send_Byte_D
	decfsz  LCD_counter, A
	bra	LCD_Loop_message
	return

LCD_Send_Byte_I:		; Transmits byte stored in W to instruction reg;
	movwf   LCD_tmp, A
	swapf   LCD_tmp, W, A   
	andlw   0x0f	    
	movwf   LATB, A	    
	bcf	LATB, LCD_RS, A	
	call    LCD_Enable  
	movf	LCD_tmp, W, A  
	andlw   0x0f	    
	movwf   LATB, A	   
	bcf	LATB, LCD_RS, A	
        call    LCD_Enable  
	return

LCD_Send_Byte_D:		; Transmits byte stored in W to data reg
	movwf   LCD_tmp, A
	swapf   LCD_tmp, W, A	
	andlw   0x0f	    
	movwf   LATB, A	   
	bsf	LATB, LCD_RS, A	
	call    LCD_Enable  
	movf	LCD_tmp, W, A
	andlw   0x0f
	movwf   LATB, A
	bsf	LATB, LCD_RS, A  
        call    LCD_Enable
	movlw	10
	call	LCD_delay_x4us
	return

LCD_Enable:			; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	LATB, LCD_E, A	; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	LATB, LCD_E, A	; Writes data to LCD
	return
    

LCD_delay_ms:			; delay given in ms in W
	movwf	LCD_cnt_ms, A
lcdlp2:	movlw	250
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms, A
	bra	lcdlp2
	return
    
LCD_delay_x4us:			; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	
	swapf   LCD_cnt_l, F, A	
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A 
	movwf	LCD_cnt_h, A
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A 
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00
lcdlp1:	decf 	LCD_cnt_l, F, A	
	subwfb 	LCD_cnt_h, F, A
	bc 	lcdlp1		
	return			


end