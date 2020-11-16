#include <xc.inc>

extrn	LCD_Write_Message
global  write_menu

psect	udata_acs  
counter:    ds 1    
    
psect	udata_bank5 
myArray:    ds 0x80 

psect	data  
myTable:
	db	'A','-','L','o','c','k',' ','B',' ','A','n','o','n',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','C','-','C','h','a','n','g','e',' ','C','o','d','e',0x0a
	myTable_l   EQU	54	; length of data
	align	2
	
psect	table_code,class=CODE	
write_menu: 	
	start: 	lfsr	0, myArray		
	movlw	low highword(myTable)	
	movwf	TBLPTRU, A		
	movlw	high(myTable)	
	movwf	TBLPTRH, A		
	movlw	low(myTable)	
	movwf	TBLPTRL, A		
	movlw	myTable_l	
	movwf 	counter, A		
loop1: 	tblrd*+			
	movff	TABLAT, POSTINC0	
	decfsz	counter, A		
	bra	loop1		
	movlw	myTable_l	
	addlw	0xff		
	lfsr	2, myArray
	call	LCD_Write_Message
	
	return
	
end