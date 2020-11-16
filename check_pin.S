#include <xc.inc>

global  pin_check_setup, check_master	;, check_master, check_new_pin, change_pin, wrong_pin, right_pin
extrn	LCD_Write_Hex, LCD_delay_ms
extrn	write_welcome_enter_code, write_menu, write_wrong
extrn   output1_compare, output2_compare, output3_compare, output4_compare  
    
psect	udata_acs   ; named variables in access ram
pin_1:	ds 1	
pin_2:	ds 1
pin_3:	ds 1	
pin_4:	ds 1
    
new_pin_1:	ds 1	
new_pin_2:	ds 1
new_pin_3:	ds 1	
new_pin_4:	ds 1

psect	pin_code,class=CODE

pin_check_setup:
    movlw   0x00
    movwf   pin_1,A
    movlw   0x00
    movwf   pin_2,A
    movlw   0x00
    movwf   pin_3,A
    movlw   0x00
    movwf   pin_4,A
    
    movlw   0x01
    movwf   new_pin_1,A
    movlw   0x01
    movwf   new_pin_2,A
    movlw   0x01
    movwf   new_pin_3,A
    movlw   0x01
    movwf   new_pin_4,A
    return
    
check_master:
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
    
    
check_new_pin:
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

wrong_pin:
    call    write_wrong
    movlw   0xFF
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    return
    
right_pin:
    call    write_menu
    movlw   0xFF
    call    LCD_delay_ms
    call    LCD_delay_ms
    call    LCD_delay_ms
    return


end