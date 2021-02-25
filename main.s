	#include <xc.inc>
; Controlling external 2 Byte memory latches
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme Setup Code ******
setup:	
	movlw 	0x0		    ; Put 0 to W register
	movwf	TRISD, A	    ; Move contents of W to TRISD (to make it an output)
	movlw	0x0		    ; Put 0 to W register
	movwf	TRISE, A	    ; Move contents of W to TRISE (to make it an output)
	goto	start

	; ******* Control Bus operations test ******
start:
	bsf	PORTD, 0
	
	goto	0
	


	

	end	main