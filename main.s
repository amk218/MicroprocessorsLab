	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS		    ; point to Flash program memory  
	bsf	EEPGD		    ; access Flash program memory
	movlw 	0x0		    ; Put 0 to W register
	movwf	TRISC, A	    ; Move contents of W to TRISC (to make it an output)
	movlw b'11111111'	    ; Put binary 11111111 to W register
	movwf TRISD		    ; Move contents of W to TRISD (to make it an input)
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db	0b11110000, 0b00001111, 0b01010101, 0b10101010,0b10010110
	myArray EQU 0x400	    ; Address in RAM for data
	counter EQU 0x10	    ; Address of counter variable
	align	2		    ; ensure alignment of subsequent instructions 
	; ******* Main programme *********************
start:	
   
	lfsr	0, myArray	    ; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	    ; load upper bits to TBLPTRU
	movlw	high(myTable)	    ; address of data in PM
	movwf	TBLPTRH, A	    ; load high byte to TBLPTRH
	movlw	low(myTable)	    ; address of data in PM
	movwf	TBLPTRL, A	    ; load low byte to TBLPTRL
	movlw	6		    ; 22 bytes to read
	movwf 	counter, A	    ; our counter register
loop:
	nop			    ; This is to switch program on/off with PORTD pin3
	tfsc	PORTD, 3	    ; If PORTD pin 3 is 0, skip next line
	bra	$-3
    
        tblrd*+			    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTC	    ; move read data from TABLAT to PORTC	
	decfsz	counter, A	    ; count down to zero
	
	tfsc	PORTD, 0	    ; If PORTD pin 0 is 0, skip next line
	call	delay2		    ; These will adjust delay length based on PORTD input
	
	tfsc	PORTD, 1		    
	call	delay3
	
	tfsc	PORTD, 2
	call	delay4
	
	bra	loop		    ; keep going until finished
	
delay1:
	movlw   0xFF		    ; Put value 0x10 into W
	movwf   0x20, A		    ; Move value in W to file register address 0x20
	decfsz  0x20, F, A	    ; Decrement value in 0x20. If 0, skip next line
	bra	$-2
	return
	
delay2:
	call	delay1		    ; Call counter delay1
	movlw	0xFF		    ; Put the value 0x20 into W
	movwf	0x20		    ; Move value in W to file register address 0x20
	decfsz	0x20,F,A	    ; Decrement value in 0x30. If 0, skip next line
	bra	$-2
	return

delay3:
	call delay2
	movlw	0xFF
	movwf	0x20
	decfsz	0x20,F,A
	bra	$-2
	return
	
delay4:
	call delay3
	movlw	0xFF
	movwf	0x20
	decfsz	0x20, F, A
	bra	$-2
	return
	
	
	goto	0

	end	main