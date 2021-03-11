#include <xc.inc>

global	delay2
extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_clear_screen, LCD_Write_Message_line2
extrn	Keypad_Setup, LCD_Send_Byte_D, Button_Input
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine


psect	code, abs	
rst: 	org	0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS		; point to Flash program memory  
	bsf	EEPGD		; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	call	Keypad_Setup	; setup Keypad
	goto	start
	
	; ******* Main programme ****************************************
start: 
	call	Button_Input
	; We now have the hex code of the character in W register
	call	LCD_Send_Byte_D	 ; Display ascii characted on LCD
	call	delay3		 ; Longer delay to avoid typing character many times

	bra	start
	goto	$		    ; goto current line in code


	; ***** Delay subroutines *****

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
	movlw	0x10
	movwf	0x40, A
	call	delay2
	decfsz	0x40, F, A
	bra	$-6
	return

	end	rst