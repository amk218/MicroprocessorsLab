	#include <xc.inc>
; Controlling external 2 Byte memory latches
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme Setup Code ******
setup:	
	clrf	TRISD		    ; Clear TRISD to make it an output
	clrf	PORTD		    ; Clear PORTD to begin with
	goto	start

	; ******* Control Bus operations ******
	
start:
	BSF	PORTD, 1
	
	goto	0
	


	

	end	main