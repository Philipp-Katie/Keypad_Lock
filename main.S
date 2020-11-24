#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Hex, LCD_Clear, LCD_delay_ms 
extrn	keypad_setup, wait_number_input, check_anon, output1, output2, output3, output4, output_counter
extrn   write_welcome_enter_code
extrn	pin_check_setup, wrong_pin_setup, check_master, check_output
	
psect	udata_acs   
output_count_compare:	ds 1

psect	code, abs	
rst: 	org 0x0
 	goto	setup1

;Called seperately to not overwrite value
setup1:
	call	wrong_pin_setup
	goto	setup2
	
;Setup routines for the hardware and to initialize variables
setup2:
	call	LCD_Setup
	call	pin_check_setup
	call	keypad_setup
	call    write_welcome_enter_code
	goto	main
	
main:
    call	wait_number_input
    call	check_output
    goto	determine_num_display
	
;Determines how many input numbers have been recieved and displays the same amount
determine_num_display:
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
    return

write_1_num:
    call	check_anon	;Check to see if anon mode is on or off
    movf	output1,W,A
    call	LCD_Write_Hex
    movlw	0xDD		;Delay avoid reading same input multiple times
    call	LCD_delay_ms
    goto	main
    

write_2_num:
    call	check_anon	
    movf	output1,W,A
    call	LCD_Write_Hex
    movf	output2,W,A
    call	LCD_Write_Hex
    movlw	0xDD		
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
    movlw	0xDD		
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
    movlw	0xDD		
    call	LCD_delay_ms
    call	LCD_Clear
    call	check_master	    ;Checks to see if the pin is correct
    goto	setup2
	
end
