#include <xc.inc>
    
extrn	LCD_delay_x4us, LCD_delay_ms
global	output, no_input, row_split1, row_split2, row_split3, column_split1, column_split2, column_split3, column, row
global  keypad_setup, wait_number_input


psect	udata_acs   
no_input:	ds 1		    ;Predefined and unchanging variables needed to determine the correct output
row_split1:	ds 1 
row_split2:	ds 1
row_split3:	ds 1
column_split1:  ds 1
column_split2:  ds 1
column_split3:	ds 1
column:		ds 1		    ;Stores the info needed to determine the correct column
row:		ds 1		    ;Stores the info needed to determine the row
output:		ds 1		    ;Stores the actual output value (Matching the keypad input)
    
psect	keypad_number_code,class=CODE

keypad_setup:
    movlw   0x0F	
    movwf   no_input,A
    
    movlw   0x00	
    movwf   output,A
    
    movlw   0x0D   
    movwf   column_split3,A
    movlw   0x0C		    ;12
    movwf   column_split1,A
    movlw   0x09		    ;9
    movwf   column_split2,A
    movlw   0xB4		    ;180
    movwf   row_split1,A
    movlw   0x96		    ;150
    movwf   row_split3,A
    movlw   0xDC		    ;220
    movwf   row_split2,A
    return
    
wait_number_input: 
    movlb   0x0F		    ;set BSR so can access PADCFG1	
    bsf	    REPU		    ;set PORTE pull ups on
    clrf    LATE,A	
    movlw   0x0F	
    movwf   TRISE,A
    movlw   0x0A	  
    call    LCD_delay_x4us
    movff   PORTE,column,A	
    movf    no_input,W,A
    CPFSLT  column,A		    ;Only finnishes subroutine if a button is pressed
    bra     wait_number_input
    goto    number_read
    
    
number_read:
    movlw   0x0F		    ;Configre 0:3 inputs, 4:7 outputs
    movwf   TRISE,A
    movff   PORTE,column,A	    ;Read PORTE and store columns in memory
    movlw   0x0A	
    call    LCD_delay_x4us
				    ;Switch to reading other 4 pins
    movlw   0xF0		    ;Configure 0:3 outputs 4:7 inputs
    movwf   TRISE,A
    movlw   0x0A	
    call    LCD_delay_x4us
    movff   PORTE, row,A	    ;Read PORTE and store rows in memory
    goto    number_decode

number_decode:			    ;The following code determines which input was given and writes this value into the output variable
    movf    column,W,A
    cpfsgt  column_split1,A
    goto    num_column1or2
    goto    num_column3or4
    
num_column1or2:
    cpfseq  column_split3,A
    goto    num_column1rows
    goto    num_column2rows
num_column3or4:
    cpfsgt  column_split2,A
    goto    num_column3rows
    goto    num_column4rows
    return  
num_column1rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    num_c1row1or2
    goto    num_c1row3or4
num_c1row1or2:
    cpfsgt  row_split2,A
    goto    num_c1r1
    goto    num_c1r2
num_c1row3or4:
    cpfsgt  row_split3,A
    goto    num_c1r3
    goto    num_c1r4
num_c1r1:
    movlw   0x01
    movwf   output,A		    ;write 1
    return
num_c1r2:
    movlw   0x04
    movwf   output,A		    ;write 4
    return
num_c1r3:
    movlw   0x07
    movwf   output,A		    ;write 7
    return
num_c1r4:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_number_input
    
num_column2rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    num_c2row1or2
    goto    num_c2row3or4
num_c2row1or2:
    cpfsgt  row_split2,A
    goto    num_c2r1
    goto    num_c2r2
num_c2row3or4:
    cpfsgt  row_split3,A
    goto    num_c2r3
    goto    num_c2r4

num_c2r1:
    movlw   0x02
    movwf   output,A		    ;write 2
    return
num_c2r2:
    movlw   0x05
    movwf   output,A		    ;write 5
    return
num_c2r3:
    movlw   0x08
    movwf   output,A		    ;write 8
    return
num_c2r4:
    movlw   0x00
    movwf   output,A		    ;write 0
    return
    
num_column3rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    num_c3row1or2
    goto    num_c3row3or4
num_c3row1or2:
    cpfsgt  row_split2,A
    goto    num_c3r1
    goto    num_c3r2
num_c3row3or4:
    cpfsgt  row_split3,A
    goto    num_c3r3
    goto    num_c3r4

num_c3r1:
    movlw   0x03
    movwf   output,A		    ;write 3
    return
num_c3r2:
    movlw   0x06
    movwf   output,A		    ;write 6
    return
num_c3r3:
    movlw   0x09
    movwf   output,A		    ;write 9
    return
num_c3r4:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_number_input
    
num_column4rows:
    movf    row,W,A
    cpfsgt  row_split1,A
    goto    num_c4row1or2
    goto    num_c4row3or4
num_c4row1or2:
    cpfsgt  row_split2,A
    goto    num_c4r1
    goto    num_c4r2
num_c4row3or4:
    cpfsgt  row_split3,A
    goto    num_c4r3
    goto    num_c4r4

num_c4r1:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_number_input
num_c4r2:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_number_input
num_c4r3:
    movlw   0xDD
    call    LCD_delay_ms    
    goto    wait_number_input
num_c4r4:
    movlw   0xDD
    call    LCD_delay_ms
    goto    wait_number_input
    
end