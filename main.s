	#include <xc.inc>
; Delayed counter

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0		    ; Put 0 to W register
	movwf	TRISC, A	    ; Move contents of W to TRISC (Access bank)
	bra 	test		    ; Jump to test
loop:
	call	delay2		    ; Call delay counter
	movff 	0x06, PORTC	    ; Copy value from 0x06 to PORTC
	incf 	0x06, W, A	    ; Add 1 to value in 0x06 and put result into W register
test:
	movwf	0x06, A	            ; Copy value in W to file register address 0x06 (Access bank)
	movlw 	0x63		    ; Put the value 99 to W
	cpfsgt 	0x06, A		    ; Compare value at 0x06 to W. If greater than, then skip next line
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

delay1:
	movlw   0xFF		    ; Put value 0x10 into W
	movwf   0x20, A		    ; Move value in W to file register address 0x20
	decfsz  0x20, F, A	    ; Decrement value in 0x20. If 0, skip next line
	bra	$-2
	return
	
delay2:
	call	delay1		    ; Call counter delay1
	movlw	0xFF		    ; Put the value 0x20 into W
	movwf	0x30		    ; Move value in W to file register address 0x30
	decfsz	0x30,F,A	    ; Decrement value in 0x30. If 0, skip next line
	bra	$-2
	return
	
delay2:
	call	delay2
	movlw	0xFF
	movwf	0x30
	decfsz	0x30, F, A
	bra	$-2
	return
	
	end	main
