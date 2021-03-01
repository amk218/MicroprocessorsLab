	#include <xc.inc>
; Controlling external 2 Byte memory latches
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme Setup Code ******
setup:	
	clrf	TRISD, A	    ; Clear TRISD to make it an output
	clrf	PORTD, A	    ; Clear PORTD to begin with
	clrf	TRISE, A	    ; Clear TRISE to make it an output
	clrf	PORTE, A
	goto	start

	; ******* Writing a byte of data onto the flip flop ******
	
start:
	movlw	0b10101010
	movwf	LATE, A
	BSF	PORTD, 0, A	    ; Set output enable high (not enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 1, A	    ; Set clock pulse low
	BCF	PORTD, 0, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	
	call	delay3
	
	movlw	0b11111111
	movwf	LATE, A
	BSF	PORTD, 0, A	    ; Set output enable high (not enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 1, A	    ; Set clock pulse low
	BCF	PORTD, 0, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	
	call	delay3
	
	movlw	0b11110000
	movwf	LATE, A
	BSF	PORTD, 0, A	    ; Set output enable high (not enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 1, A	    ; Set clock pulse low
	BCF	PORTD, 0, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	
	call	delay3
	
	movlw	0b00001111
	movwf	LATE, A
	BSF	PORTD, 0, A	    ; Set output enable high (not enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 1, A	    ; Set clock pulse low
	BCF	PORTD, 0, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	
	call	delay3
	
	
	
	goto	0
	


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
	
	end	main

	

