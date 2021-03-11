#include <xc.inc>

global	    Keypad_Setup, Button_Input
extrn	    LCD_delay_x4us, delay2
    
psect	udata_acs      ; named variables in access ram
row_press:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
column_press:	ds 1   ; reserve 1 byte for variable LCD_cnt_h

    

psect	    keypad_code, class=CODE
	
Keypad_Setup:
	banksel	PADCFG1
	bsf	REPU		    ; Enable weak pull-up resistors
	movlb	0
	clrf	LATE		    ; Clear ports and latches
	clrf	TRISH
	clrf	LATH
	clrf	TRISJ
	clrf	LATJ
	clrf	TRISD
	clrf	LATD
	return
	
Find_Row:
	movlw	0b00001111
	movwf	TRISE, A
	movwf	LATE, A
	movlw	1
	call	LCD_delay_x4us	    ; 4us delay
	movff	PORTE, row_press
	return
	
Find_Column:
	movlw	0b11110000
	movwf	TRISE, A
	movwf	LATE, A
	movlw	1
	call	LCD_delay_x4us	    ; 4us delay
	movff	PORTE, column_press
	return
	
Decode_Button:
	movf	row_press, 0, 0
	iorwf	column_press, 0, 0  ; Inclusive OR of row and column inputs
	movwf	LATH, A
	comf	LATH, 0, 0  ; NOT(LATH)
	movwf	LATH, A
	call	delay2
	
Which_Button:
	movlw	0b00000000  ; No button pressed
	cpfseq	LATH, A
	bra	$+4
	bra	Clear_Stack
	
	movlw	0b10000010  ; Button 0
	cpfseq	LATH, A
	bra	$+4
	retlw	0x30
	
	movlw	0b00010001  ; Button 1
	cpfseq	LATH, A
	bra	$+4
	retlw	0x31
	
	movlw	0b00010010  ; Button 2
	cpfseq	LATH, A
	bra	$+4
	retlw	0x32
	
	movlw	0b00010100  ; Button 3
	cpfseq	LATH, A
	bra	$+4
	retlw	0x33
	
	movlw	0b00100001  ; Button 4
	cpfseq	LATH, A
	bra	$+4
	retlw	0x34
	
	movlw	0b00100010  ; Button 5
	cpfseq	LATH, A
	bra	$+4
	retlw	0x35
	
	movlw	0b00100100  ; Button 6
	cpfseq	LATH, A
	bra	$+4
	retlw	0x36
	
	movlw	0b01000001  ; Button 7
	cpfseq	LATH, A
	bra	$+4
	retlw	0x37
	
	movlw	0b01000010  ; Button 8
	cpfseq	LATH, A
	bra	$+4
	retlw	0x38
	
	movlw	0b01000100  ; Button 9
	cpfseq	LATH, A
	bra	$+4
	retlw	0x39
	
	movlw	0b10000001  ; Button A
	cpfseq	LATH, A
	bra	$+4
	retlw	0x41
	
	movlw	0b10000100  ; Button B
	cpfseq	LATH, A
	bra	$+4
	retlw	0x42
	
	movlw	0b10001000  ; Button C
	cpfseq	LATH, A
	bra	$+4
	retlw	0x43
	
	movlw	0b01001000  ; Button D
	cpfseq	LATH, A
	bra	$+4
	retlw	0x44
	
	movlw	0b00101000  ; Button E
	cpfseq	LATH, A
	bra	$+4
	retlw	0x45
	
	movlw	0b00011000  ; Button F
	cpfseq	LATH, A
	bra	$+4
	retlw	0x46
    
Clear_Stack:		    ; If no button pressed, or non-valid combination, 
	POP		    ; drop one item from return stack to go back to main loop
	
Button_Input:
	call	Find_Column
	movlw	1
	call	LCD_delay_x4us
	call	Find_Row
	movlw	1
	call	LCD_delay_x4us
	call	Decode_Button
	return
	
    

	
    





