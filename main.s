#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_clear_screen, LCD_Write_Message_line2
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'H','e','l','l','o',' ','W','o','r','l','d',',',' ','y','o','u',' ','s','u','c','k','!', 0x0a
					; message, plus carriage return
	myTable_l   EQU	23	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	movlw	0b11111111
	movwf	TRISD, A
	goto	start
	
	; ******* Main programme ****************************************
start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	myTable_l	; output message to UART
	lfsr	2, myArray
	call	UART_Transmit_Message



	
test:					    ; decides using RD0 which line of LCD to write to
	btfss	PORTD, 0, A		    ; If PORTD pin 0 is 1, skip next line
	call	Write_line1
	btfsc	PORTD, 0, A		    ; If PORTD pin 0 is 0, skip next line
	call	Write_line2
	call	delay3

	bra	test
	goto	$		    ; goto current line in code
	

Write_line1:			   ; Writes to line 1 of LCD
	call	LCD_clear_screen
	movlw	myTable_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message
	return
Write_line2:			    ; Writes to line 2 of LCD
	call	LCD_clear_screen
	movlw	myTable_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message_line2
	return

	
	



	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return
	
delay1:
	movlw   0xFF		    ; Put value 0x10 into W
	movwf   0x20, A		    ; Move value in W to file register address 0x20
	decfsz  0x20, F, A	    ; Decrement value in 0x20. If 0, skip next line
	bra	$-2
	return
	
delay2:
	movlw	0xFF		    ; Put the value 0x20 into W
	movwf	0x30, A		    ; Move value in W to file register address 0x30
	call	delay1		    ; Call counter delay1
	decfsz	0x30,F,A	    ; Decrement value in 0x30. If 0, skip next line
	bra	$-6
	return
	
delay3:
	movlw	0x50
	movwf	0x40, A
	call	delay2
	decfsz	0x40, F, A
	bra	$-6
	return

	end	rst