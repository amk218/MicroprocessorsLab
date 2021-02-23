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
	movlw	0b11111111	    ; Put binary 11111111 to W register
	movwf	TRISD		    ; Move contents of W to TRISD (to make it an input)
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
	movlw	5		    ; 22 bytes to read
	movwf 	counter, A	    ; our counter register
loop:
	nop			    ; This is to switch program on/off with PORTD pin3
	btfsc	PORTD, 3	    ; If PORTD pin 3 is 0, skip next line
	bra	$-3
    
        tblrd*+			    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTC	    ; move read data from TABLAT to PORTC	
	
	btfsc	PORTD, 0	    ; If PORTD pin 0 is 0, skip next line
	call	delay2		    ; These will adjust delay length based on PORTD input
	
	btfsc	PORTD, 1		    
	call	delay3
	
	btfsc	PORTD, 2
	call	delay4
	
	decfsz	counter, A	    ; count down to zero
	bra	loop		    ; keep going until finished
	goto	0x00		    ; Re-run program
	
delay1:
	movlw   0xFF		    ; Put value 0x10 into W
	movwf   0x20, A		    ; Move value in W to file register address 0x20
	decfsz  0x20, F, A	    ; Decrement value in 0x20. If 0, skip next line
	bra	$-2
	return
	
delay2:
	movlw	0xFF		    ; Put the value 0x20 into W
	movwf	0x30		    ; Move value in W to file register address 0x20
	call	delay1		    ; Call counter delay1
	decfsz	0x30, F, A	    ; Decrement value in 0x30. If 0, skip next line
	bra	$-6
	return

delay3:
	movlw	0x10
	movwf	0x40
	call	delay2
	decfsz	0x40,F,A
	bra	$-6
	return
	
delay4:
	movlw	0x10
	movwf	0x50
	call	delay3
	decfsz	0x50, F, A
	bra	$-6
	return
	

	end	main