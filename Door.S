#include <xc.inc>

extrn	LCD_delay_ms
	
global  door_open, door_close
	
psect	door_code,class=CODE
	
 door_open:
    bcf	    TRISG, 0, A	    ;Set IO port to output
    movlw   0x02	    ;Length of delay defines position of servo motor
    call    LCD_delay_ms
    bsf	    TRISG, 0, A	    ;Set IO port to input
    return
 
door_close:
    bcf	    TRISG, 0, A	    ;Set IO port to output
    movlw   0x01
    call    LCD_delay_ms
    bsf	    TRISG, 0, A	    ;Set IO port to input
    return    
        
end