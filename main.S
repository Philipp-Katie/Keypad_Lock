#include <xc.inc>

;extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
;extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	keypad_setup, keypad_start, check_anon, output, output1, output2, output3, output4, output_counter
extrn   write_welcome_enter_code, write_menu, write_wrong
extrn	pin_check_setup, check_master
	
psect	udata_acs   ; reserve data space in access ram
delay_count:		ds 1    ; reserve one byte for counter in the delay routine
output_count_compare:	ds 1

psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	;call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	;call	ADC_Setup	; setup ADC
	call	keypad_setup
	call	pin_check_setup
	call    write_welcome_enter_code
	call	keypad_start
	goto	measure_loop


	
main:
    ;movlw	0xFF
    ;call	LCD_delay_ms
    ;call	LCD_delay_ms
    call	keypad_start
	
measure_loop:
	;lcall	ADC_Read
	;movf	ADRESH, W, A
	;call	LCD_Write_Hex
	;movf	ADRESL, W, A#
    call    LCD_Clear
    movlw   0x04
    movwf   output_count_compare,A
    movf    output_counter,W,A
    cpfsgt  output_count_compare,A
    goto    write_4_num
    decf    output_count_compare,A
    cpfsgt  output_count_compare,A
    goto    write_3_num
    decf    output_count_compare,A
    cpfsgt  output_count_compare,A
    goto    write_2_num
    decf    output_count_compare,A
    cpfsgt  output_count_compare,A
    goto    write_1_num
    ;goto    $
    return
    
	;goto	measure_loop		; goto current line in code

write_1_num:
    call	check_anon	
    movf	output1,W,A
    call	LCD_Write_Hex
    movlw	0xAA		;Delay avoid reading same input multiple times
    call	LCD_delay_ms
    call	LCD_delay_ms
    goto	main
    

write_2_num:
    call	check_anon	
    movf	output1,W,A
    call	LCD_Write_Hex
    movf	output2,W,A
    call	LCD_Write_Hex
    movlw	0xAA		;Delay avoid reading same input multiple times
    call	LCD_delay_ms
    call	LCD_delay_ms
    goto	main
    
write_3_num:
    call	check_anon	
    movf	output1,W,A
    call	LCD_Write_Hex
    movf	output2,W,A
    call	LCD_Write_Hex
    movf	output3,W,A
    call	LCD_Write_Hex
    movlw	0xAA		;Delay avoid reading same input multiple times
    call	LCD_delay_ms
    call	LCD_delay_ms
    goto	main
    
write_4_num:
    call	check_anon	
    movf	output1,W,A
    call	LCD_Write_Hex
    movf	output2,W,A
    call	LCD_Write_Hex
    movf	output3,W,A
    call	LCD_Write_Hex
    movf	output4,W,A
    call	LCD_Write_Hex
    movlw	0xFF		;Delay avoid reading same input multiple times
    call	LCD_delay_ms
    call	LCD_delay_ms
    call	LCD_Clear
    call	check_master
    ;call	write_welcome_human
    ;call checking subroutine
    ;display message and then ask for different input
    ;goto	$
	
	end	rst
