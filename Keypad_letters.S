#include <xc.inc>
    
extrn	LCD_delay_x4us, LCD_delay_ms
extrn	check_output, change_anon, lock, change_pin 
extrn	no_input, row_split1, row_split2, row_split3, column_split1, column_split2, column_split3, column, row
global  wait_letter_input
    
psect	keypad_letter_code,class=CODE
    
wait_letter_input: 
    movlb   0x0F	
    bsf	    REPU	
    clrf    LATE,A	
    movlw   0x0F	
    movwf   TRISE,A
    movlw   0x0A	  
    call    LCD_delay_x4us
    movff   PORTE,column,A	
    movf    no_input,W,A
    CPFSLT  column,A
    bra     wait_letter_input
    goto    letter_read
    return
    
letter_read:
    movlb   0x0F		
    bsf	    REPU	
    clrf    LATE,A		
    movlw   0x0F	
    movwf   TRISE,A
    movff   PORTE,column,A	
    movlw   0x0A	
    call    LCD_delay_x4us
				
    movlw   0xF0	
    movwf   TRISE,A
    movlw   0x0A	
    call    LCD_delay_x4us
    movff   PORTE, row,A
    goto    letter_decode

letter_decode:
    movf    column,W,A
    cpfsgt  column_split1,A
    goto    let_column1or2
    goto    let_column3or4
    
let_column1or2:
    cpfseq  column_split3,A
    goto    let_column1rows
    goto    let_column2rows
let_column3or4:
    cpfsgt  column_split2,A
    goto    let_column3rows
    goto    let_column4rows
    return  
let_column1rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    let_c1row1or2
    goto    let_c1row3or4
let_c1row1or2:
    cpfsgt  row_split2,A
    goto    let_c1r1
    goto    let_c1r2
let_c1row3or4:
    cpfsgt  row_split3,A
    goto    let_c1r3
    goto    let_c1r4

let_c1r1:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c1r2:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c1r3:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c1r4:			    ;Calls locking subroutine
    call     lock
    return
    
let_column2rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    let_c2row1or2
    goto    let_c2row3or4
let_c2row1or2:
    cpfsgt  row_split2,A
    goto    let_c2r1
    goto    let_c2r2
let_c2row3or4:
    cpfsgt  row_split3,A
    goto    let_c2r3
    goto    let_c2r4

let_c2r1:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c2r2:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c2r3:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c2r4:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
    
let_column3rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    let_c3row1or2
    goto    let_c3row3or4
let_c3row1or2:
    cpfsgt  row_split2,A
    goto    let_c3r1
    goto    let_c3r2
let_c3row3or4:
    cpfsgt  row_split3,A
    goto    let_c3r3
    goto    let_c3r4

let_c3r1:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c3r2:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c3r3:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c3r4:			    ;Calls change anon mode subroutine
    call    change_anon
    return
    
let_column4rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    let_c4row1or2
    goto    let_c4row3or4
let_c4row1or2:
    cpfsgt  row_split2,A
    goto    let_c4r1
    goto    let_c4r2
let_c4row3or4:
    cpfsgt  row_split3,A
    goto    let_c4r3
    goto    let_c4r4

let_c4r1:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c4r2:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c4r3:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_letter_input
let_c4r4:			;Calls change pin subroutine
    call     change_pin
    return
    
end