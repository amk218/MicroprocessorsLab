	#include <xc.inc>
; This code sends byte patterns to an external shift register, using SPI as a "serial link"
psect	code, abs
main:
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme Setup Subroutine *****  
SPI_MasterInit:
	
	clrf	PORTD
	clrf	TRISD
	Banksel	SSP2STAT
	BCF	CKE		    ; CKE bit in SSP2STAT
	movlb	0x00
	; MSSP enable; CKP=1, SPI master, clock=Fosc/64 (=1MHz)
	movlw	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
	movwf	SSP2CON1, A
	; SDO2 output; SCK2 output
	BCF	TRISD, PORTD_SDO2_POSN, A ; SDO2 output
	BCF	TRISD, PORTD_SCK2_POSN, A ; SCK2 output
	BSF	PORTD, 0, A	    ; Set master reset (off)
	
	return
	
	
	; ******* Delay subroutines ******
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
	
	
	; ******* Serial data transmission subroutines *****
SPI_MasterTransmit:		    ; Start transmission of data (held in W)
	movwf	SSP2BUF, A	    ; Write data to output buffer
	return
	
Wait_Transmit:			    ; Wait for transmission to be complete
	btfss	SSP2IF		    ; Check interrupt flag to see if data has been sent
	bra	Wait_Transmit
	BCF	SSP2IF		    ; Clear interrupt flag
	return


	; ******* Main programme *******
start:
	call	SPI_MasterInit	    ; Setup SPI
	movlw	0b11111111
	call	SPI_MasterTransmit
	call	Wait_Transmit
	call	delay3
	BCF	PORTD, 0, A	    ; Clear master reset (on)
	call	delay1		    ; Shift register has been reset
	BSF	PORTD, 0, A	    ; Set master reset (off)
	
	movlw	0b10101010
	call	SPI_MasterTransmit
	call	Wait_Transmit
	call	delay3
	BCF	PORTD, 0, A	    ; Clear master reset (on)
	call	delay1		    ; Shift register has been reset
	BSF	PORTD, 0, A	    ; Set master reset (off)
	
	movlw	0b10001000
	call	SPI_MasterTransmit
	call	Wait_Transmit
	call	delay3
	BCF	PORTD, 0, A	    ; Clear master reset (on)
	call	delay1		    ; Shift register has been reset
	BSF	PORTD, 0, A	    ; Set master reset (off)
	
	goto	0
	
	 
	
	
	




	end	main