#include <xc.inc>

extrn	LCD_Write_Message ; external LCD subroutines

global  write_welcome_enter_code ;, write_welcome
    
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
;counter2:   ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data
;myArray2:   ds 0x80
    
;psect	table_code,class=udata ; reserve data anywhere in RAM (here at 0x400)    
    
psect	data  
myTable:
	db	'W','e','l','c','o','m','e',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','E','n','t','e','r',' ','C','o','d','e',0x0a
	myTable_l   EQU	51	; length of data
	align	2
	
;psect	data
;myTable2:
;	db	'W','e','l','c','o','m','e',0x0a
;	myTable_2   EQU	8	; length of data
;	align	2
	
psect	table_code,class=CODE	
	; ******* Main programme ****************************************#
write_welcome_enter_code: 	
	start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter, A		; our counter register
loop1: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop1		; keep going until finished
	movlw	myTable_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message
	
	return

;write_welcome_human: 	
;	start: 	lfsr	0, myArray2	; Load FSR0 with address in RAM	
;	movlw	low highword(myTable2)	; address of data in PM
;	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
;	movlw	high(myTable2)	; address of data in PM
;	movwf	TBLPTRH, A		; load high byte to TBLPTRH
;	movlw	low(myTable2)	; address of data in PM
;	movwf	TBLPTRL, A		; load low byte to TBLPTRL
;	movlw	myTable_2	; bytes to read
;	movwf 	counter2, A		; our counter register
;loop2: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter2, A		; count down to zero
;	bra	loop2		; keep going until finished
;	movlw	myTable_2	; output message to LCD
;	addlw	0xff		; don't send the final carriage return to LCD
;	lfsr	2, myArray2
;	call	LCD_Write_Message
	
;	return
	
end
	
