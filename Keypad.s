#include <xc.inc>

global	    test_buttons, Keypad_Setup
extrn	    LCD_delay_x4us
    
psect	udata_acs      ; named variables in access ram
row_press:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
column_press:	ds 1   ; reserve 1 byte for variable LCD_cnt_h

    
psect	    code
	    
Keypad_Setup:
	bsf	PADCFG1, REPU, B    ; Enable pull-up resistors
	clrf	LATE		    ; Clear PORTE latch
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
	movf	row_press, W, A
	andwf	column_press, W, A
	movwf	PORTD
	return
	
	
test_buttons:
	call	Keypad_Setup
	call	Find_Column
	movlw	1
	call	LCD_delay_x4us
	call	Find_Row
	movlw	1
	call	LCD_delay_x4us
	call	Decode_Button
	bra	test_buttons
    

	
    


