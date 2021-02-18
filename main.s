	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0		    ; Put 0 to W register
	movwf	TRISC, A	    ; Move contents of W to TRISC (to make it an output)
	movlw b'11111111'	    ; Put binary 11111111 to W register
	movwf TRISD		    ; Move contents of W to TRISD (to make it an input)
	bra 	test		    ; Jump to test
loop:
	movff 	0x06, PORTC	    ; Copy value from 0x06 to PORTC
	incf 	0x06, W, A	    ; Add 1 to value in 0x06 and put result into W register
test:
	movwf	0x06, A	            ; Copy value in W to file register address 0x06 (Access bank)
	
	btfsc PORTD,0		    ; If PORTD pin 0 is 0, skip next line
	movlw 0xFF		    ; Set W (counter limit) to 0xFF
	
	btfsc PORTD,1		    ; If PORTD pin 1 is 0, skip next line
	movlw 0x11		    ; Set W (counter limit) to 0x11
	
	cpfsgt 	0x06, A		    ; Compare value at 0x06 to W. If greater than, then skip next line
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
