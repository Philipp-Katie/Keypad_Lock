#include <xc.inc>

global  pin_check_setup, wrong_pin_setup, check_master
global  check_anon, check_output
global	lock, change_pin, change_anon
global  output1, output2, output3, output4, output_counter
extrn	LCD_delay_ms, LCD_Clear
extrn   wait_letter_input, wait_number_input
extrn	write_menu, write_wrong 
extrn	output
extrn	buzzer_on, door_open, door_close, buzzer_off
    
psect	udata_acs   
pin_1:		    ds 1    ;Predefined master pin 0000	
pin_2:		    ds 1
pin_3:		    ds 1	
pin_4:		    ds 1
    
new_pin_1:	    ds 1    ;User defined pin
new_pin_2:	    ds 1
new_pin_3:	    ds 1	
new_pin_4:	    ds 1

output1:	    ds 1    
output2:	    ds 1
output3:	    ds 1
output4:	    ds 1
output_compare:	    ds 1    ;Constant compare variables
output1_compare:    ds 1
output2_compare:    ds 1
output3_compare:    ds 1
output4_compare:    ds 1
output_counter:	    ds 1
    
anon:		    ds 1    ;anon status variable
anon_compare:	    ds 1    ;Constant compare variable

num_wrong:	    ds 1    ;Counts how often wrong pin was entered
num_wrong_compare:  ds 1    ;Constant compare variable
    
psect	pin_code,class=CODE

wrong_pin_setup:	    ;Defines variables that should not be reset
    movlw   0x00
    movwf   num_wrong,A
    movwf   anon,A
    return
    
pin_check_setup:	    ;Sets the master pin
    movlw   0x00
    movwf   pin_1,A
    movlw   0x00
    movwf   pin_2,A
    movlw   0x00
    movwf   pin_3,A
    movlw   0x00
    movwf   pin_4,A
    
    movlw   0x01
    movwf   anon_compare,A
    
    movlw   0x11	
    movwf   output_compare,A
    movlw   0x12	
    movwf   output1_compare,A
    movwf   output2_compare,A
    movwf   output3_compare,A
    movwf   output4_compare,A
    movlw   0x04	
    movwf   output_counter,A
    
    movlw   0x03
    movwf   num_wrong_compare,A
    
    return
    
check_anon:			;Writes F instead of the corresponding number
    movf    anon,W,A
    cpfseq  anon_compare,A
    return
    movlw   0x0F    
    movwf   output1,A
    movwf   output2,A
    movwf   output3,A
    movwf   output4,A    
    return
    
check_output:			;check to see what output to store the input in 
    movf    output1_compare,W,A
    cpfsgt  output_compare,A
    goto    write_output1
    movf    output2_compare,W,A
    cpfsgt  output_compare,A
    goto   write_output2
    movf    output3_compare,W,A
    cpfsgt  output_compare,A
    goto   write_output3
    movf    output4_compare,W,A
    cpfsgt  output_compare,A
    goto   write_output4
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
    
check_master:			    ;Compares the input pin with the master pin
    movf    pin_1,W,A
    cpfseq  output1_compare,A
    goto    check_new_pin
    movf    pin_2,W,A
    cpfseq  output2_compare,A
    goto    check_new_pin
    movf    pin_3,W,A
    cpfseq  output3_compare,A
    goto    check_new_pin
    movf    pin_4,W,A
    cpfseq  output4_compare,A
    goto    check_new_pin
    goto    right_pin
    
    
check_new_pin:			    ;Compares the input pin with the user set pin
    movf    new_pin_1,W,A
    cpfseq  output1_compare,A
    goto    wrong_pin
    movf    new_pin_2,W,A
    cpfseq  output2_compare,A
    goto    wrong_pin
    movf    new_pin_3,W,A
    cpfseq  output3_compare,A
    goto    wrong_pin
    movf    new_pin_4,W,A
    cpfseq  output4_compare,A
    goto    wrong_pin
    goto    right_pin

wrong_pin:			    ;Called if wrong pin is entered
    call    write_wrong
    incf    num_wrong,A		    ;Increments the number of wrong attempts counter
    movf    num_wrong,W,A
    cpfseq  num_wrong_compare,A
    goto    normal_wrong_pin
    goto    really_wrong_pin
    
normal_wrong_pin:		    ;Called after a wrong attempt, activates the buzzer
    call    buzzer_on
    movlw   0xFF
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    buzzer_off
    return
    
really_wrong_pin:		    ;Called after 3 wrong attempts
    movlw   0x00
    movwf   num_wrong,A		    ;resets the new pin to the original master pin
    movf    pin_1,W,A
    movwf   new_pin_1,A
    movf    pin_2,W,A
    movwf   new_pin_2,A
    movf    pin_3,W,A
    movwf   new_pin_3,A
    movf    pin_4,W,A
    movwf   new_pin_4,A
    call    buzzer_on		    ;Activates the buzzer for a longer time
    movlw   0xFF
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    buzzer_off
    return
    
right_pin:
    movlw   0x00
    movwf   num_wrong,A		    ;Resets the number of wrong attempts counter
    call    door_open		    ;Opens the door
    call    write_menu		    ;Displays the options menu
    call    wait_letter_input	    ;Waits for a letter input
    return

lock:
    call    LCD_Clear		    ;Clears LCD
    call    door_close		    ;Closes door
    movlw   0xFF
    call    LCD_delay_ms
    return

change_pin:			    ;Takes 4 number input values and saves them as user set pin
    call    LCD_Clear
    call    wait_number_input
    movf    output,W,A
    movwf   new_pin_1, A
    movlw   0xDD		    ;Delay avoid reading same input multiple times
    call    LCD_delay_ms
    call    wait_number_input
    movf    output,W,A
    movwf   new_pin_2, A
    movlw   0xDD		
    call    LCD_delay_ms
    call    wait_number_input
    movf    output,W,A
    movwf   new_pin_3, A
    movlw   0xDD		
    call    LCD_delay_ms
    call    wait_number_input
    movf    output,W,A
    movwf   new_pin_4, A
    movlw   0xDD		
    call    LCD_delay_ms
    call    lock
    return

change_anon:			;Checks if anon mode is on or off and then changes mode accordingly
    movlw   0x88		
    call    LCD_delay_ms
    call    LCD_delay_ms
    movf    anon,W,A
    cpfseq  anon_compare,A
    goto    make_anon
    goto    make_visible
     

make_anon:
    movlw   0x01
    movwf   anon,A
    call    lock
    return
    
make_visible:
    movlw   0x00
    movwf   anon,A
    call    lock
    return
    
end