#include <xc.inc>
	
global  buzzer_on, buzzer_off
	
psect	buzzer_code,class=CODE
	
buzzer_on:
			    ;Set PWM Period 
    movlw   11111111B	    ;this is the lowest pitch possible(11111111)
    movwf   PR2, A
    
    movlw   00111100B	    ;Set pins to PWM Mode
    movwf   CCP1CON, A
 
    bcf	    TRISC, 2, A	    ;Set IO port to output
    			    
    movlw   00000111B	    ;Set the prescalar
    movwf   T2CON, A
    
    movlw   00000001B	    ;Set the duty cycle
    movwf   CCPR1L, A
    return
    	    
 buzzer_off:
    bsf	TRISC, 2, A	    ;Set IO port to input
    return
    
    
end