#include <xc.inc>
    
;extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_delay_x4us, LCD_delay_ms, LCD_Write_Hex, LCD_Clear
;extrn	write_table_start
global  wait_letters
global	output, output1, output2, output3, output4, output_counter,output1_compare, output2_compare, output3_compare, output4_compare 

psect	udata_acs   ; reserve data space in access ram
no_input:	ds 1
row_split1:	ds 1
row_split2:	ds 1
row_split3:	ds 1
column_split1:  ds 1
column_split2:  ds 1
column_split3:	ds 1    ; reserve one byte for a counter variable
column:		ds 1
row:		ds 1
output_compare:	ds 1
output:		ds 1
output1:	ds 1
output2:	ds 1
output3:	ds 1
output4:	ds 1
output1_compare:    ds 1
output2_compare:    ds 1
output3_compare:    ds 1
output4_compare:    ds 1
output_counter: ds 1
anon:		ds 1	;0 if diplay shows numbers, 1 if display hides number values
anon_compare:	ds 1	;always constant, only to compare
   
psect	keypad_code,class=CODE
    
wait_letters:
    movlb   0x0F	;set BSR so can access PADCFG1 changed from 0x0F
    bsf	    REPU	;set PORTE pull ups on
    clrf    LATE,A	;Clear LATE
    movlw   0x0F	;Configre 0:3 inputs, 4:7 outputs
    movwf   TRISE,A
    movlw   0x0A	;call 40 microsecond delay  
    call    LCD_delay_x4us
    movff   PORTE,column,A	;Read PORTE and store columns in memory
    movf    no_input,W,A
    CPFSLT  column,A
    bra     wait_letters
    call    keypad_read
    return
    
    
write_output1:
    movff   output, output1
    movff   output, output1_compare
    movlw   0x01
    movwf   output_counter,A
    return
    
write_output2:
    movff   output, output2,A
    movff   output, output2_compare
    movlw   0x02
    movwf   output_counter,A
    return

write_output3:
    movff   output, output3,A
    movff   output, output3_compare
    movlw   0x03
    movwf   output_counter,A
    return    
    
write_output4:
    movff   output, output4,A
    movff   output, output4_compare
    movlw   0x04
    movwf   output_counter,A
    return

 keypad_decode_letters:
    movf    column,W,A
    cpfsgt  column_split1,A
    goto    column1or2
    goto    column3or4
    
column1or2:
    cpfseq  column_split3,A
    goto    column1rows
    goto    column2rows
    
 column3or4:
    cpfsgt  column_split2,A
    goto    column3rows
    goto    column4rows
    return
    
column1rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    c1row1or2
    goto    c1row3or4
c1row1or2:
    cpfsgt  row_split2,A
    goto    c1r1
    goto    c1r2
    
c1row3or4:
    cpfsgt  row_split3,A
    goto    c1r3
    goto    c1r4

c1r1:
    movlw   0x01
    movwf   output,A    ;write 1
    call    check_output
    return
c1r2:
    movlw   0x04
    movwf   output,A    ;write 4
    call    check_output
    return
c1r3:
    movlw   0x07
    movwf   output,A    ;write 7
    call    check_output
    return
c1r4:
    movlw   0x0A
    movwf   output,A    ;write A
    call    check_output
    return
    
 column2rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    c2row1or2
    goto    c2row3or4
c2row1or2:
    cpfsgt  row_split2,A
    goto    c2r1
    goto    c2r2
    
c2row3or4:
    cpfsgt  row_split3,A
    goto    c2r3
    goto    c2r4

c2r1:
    movlw   0x02
    movwf   output,A    ;write 2
    call    check_output
    return
c2r2:
    movlw   0x05
    movwf   output,A    ;write 5
    call    check_output
    return
c2r3:
    movlw   0x08
    movwf   output,A    ;write 8
    call    check_output
    return
c2r4:
    movlw   0x00
    movwf   output,A    ;write 0
    call    check_output
    return
    
 column3rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    c3row1or2
    goto    c3row3or4
c3row1or2:
    cpfsgt  row_split2,A
    goto    c3r1
    goto    c3r2
    
c3row3or4:
    cpfsgt  row_split3,A
    goto    c3r3
    goto    c3r4

c3r1:
    movlw   0x03
    movwf   output,A    ;write 3
    call    check_output
    return
c3r2:
    movlw   0x06
    movwf   output,A    ;write 6
    call    check_output
    return
c3r3:
    movlw   0x09
    movwf   output,A    ;write 9
    call    check_output
    return
c3r4:
    movlw   0x0B
    movwf   output,A    ;write B
    call    check_output
    return
    
 column4rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    c4row1or2
    goto    c4row3or4
c4row1or2:
    cpfsgt  row_split2,A
    goto    c4r1
    goto    c4r2
    
c4row3or4:
    cpfsgt  row_split3,A
    goto    c4r3
    goto    c4r4

c4r1:
    movlw   0x0F
    movwf   output,A    ;write F
    call    check_output
    return
c4r2:
    movlw   0x0E
    movwf   output,A    ;write E
    call    check_output
    return
c4r3:
    movlw   0x0D
    movwf   output,A    ;write D
    call    check_output
    return
c4r4:
    movlw   0x0C
    movwf   output,A    ;write C
    call    check_output
    return