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
	clrf	PORTC, A
	clrf	TRISC, A
	goto	ControlSeq

	; ******* Writing&Reading external memory flip flops ******
	
ControlSeq: ; Test protocol
    
    call Write1b
    call Read1b
    call delay3
    call Write2b
    call Read2b
    call delay3

    
    goto	0
	 
	
Write1b: ; Write data onto external flip flop
	movlw	0b10101010
	clrf	TRISE, A
	movwf	LATE, A
	BSF	PORTD, 0, A	    ; Set output enable high (disabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 1, A	    ; Set clock pulse low
	call	delay3
	return
	
Read1b:	; Read from external flip flop and show data on PORTF
	setf	TRISE, A	    ; Set TRISE to switch E to be an input
	BCF	PORTD, 0, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 1, A	    ; Set clock pulse high
	call	delay1
	movff	PORTE, PORTC	    ; Display output on PORTF
	BCF	PORTD, 1, A
	BSF	PORTD, 0, A	    ; Set output enable high (Disabled)

	return
	

Write2b: ; Write data onto external flip flop
	movlw	0b10011001
	clrf	TRISE, A
	movwf	LATE, A
	BSF	PORTD, 6, A	    ; Set output enable high (disabled)
	call	delay1
	BSF	PORTD, 7, A	    ; Set clock pulse high
	call	delay1
	BCF	PORTD, 7, A	    ; Set clock pulse low
	call	delay3
	return
	
Read2b:	; Read from external flip flop and show data on PORTF
	setf	TRISE, A		    ; Set TRISE to switch E to be an input
	BCF	PORTD, 6, A	    ; Set output enable low (enabled)
	call	delay1
	BSF	PORTD, 7, A	    ; Set clock pulse high
	call	delay1
	movff	PORTE, PORTC	    ; Display output on PORTF
	BCF	PORTD, 7, A
	BSF	PORTD, 6, A	    ; Set output enable high (Disabled)
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
	


	

