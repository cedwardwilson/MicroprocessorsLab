	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Clear, LCD_Move    ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res	1   ; reserve one byte for a counter variable	;res 1
delay_count res 1   ; reserve one byte for counter in the delay routine	;res 1

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data	;res 0x80

rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Happy Tuesday!\n"	; message, plus carriage return
	constant    myTable_l=.15	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	goto	start
	
	; ******* Main programme ****************************************
start	call	Keypad
	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
		
	call	LCD_Move	
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	call	LCD_Write_Message

	movlw	myTable_l	; output message to UART
	lfsr	FSR2, myArray
	call	UART_Transmit_Message
	
Clear	movlw	0xff
	movwf	TRISD
	movlw	0x00
	cpfsgt	PORTD, ACCESS
	bra	Clear
	call	LCD_Clear

goto	$		; goto current line in code
	
Keypad	
	call	Translator
	banksel	PADCFG1
	bsf	PADCFG1, REPU, BANKED
	movlb	0x0
	clrf	LATE
	movlw	0x0f
	movwf	TRISE
	call	delay
	movwf	PORTE
	call	delay
	movf	PORTE, W, ACCESS
	movwf	0x02, ACCESS
	
	movlw	0xf0
	movwf	TRISE
	call	delay
	movwf	PORTE
	call	delay
	movf	PORTE, W, ACCESS
	addwf	0x02
		
	movf	0x02, W, ACCESS
	clrf	TRISH
	movwf	PORTH
	
Translator  
	movlw   1
	movwf   BSR, ACCESS
	movlw	'1'
	movwf	0x77, BANKED
	movlw	'2'
	movwf	0xB7, BANKED
	movlw	'3'
	movwf	0xD7, BANKED
	movlw	'4'
	movwf	0x7B, BANKED
	movlw	'5'
	movwf	0xBB, BANKED
	movlw	'6'
	movwf	0xDB, BANKED
	movlw	'7'
	movwf	0x7D, BANKED
	movlw	'8'
	movwf	0xBD, BANKED
	movlw	'9'
	movwf	0xDD, BANKED
	movlw	'A'
	movwf	0xE7, BANKED
	movlw	'B'
	movwf	0xEB, BANKED
	movlw	'C'
	movwf	0xED, BANKED
	movlw	'D'
	movwf	0xEE, BANKED
	movlw	'*'
	movwf	0x7E, BANKED
	movlw	'#'
	movwf	0xDE, BANKED
	return
	


	

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

	end