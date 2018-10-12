	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0x0
	movwf	TRISD, ACCESS
	movwf	TRISE, ACCESS	    ;set E to output
	movlw	0xff
	movwf	TRISC, ACCESS	    ;set C to input
	movlw	0x63
	movwf	0x01, ACCESS	    ;store literal 99 decimal at address
	movff	0x01, PORTE	    ;move literal at address to PORTE
input	movf	PORTC, W, ACCESS    ;move PORTC's input to W
	movwf	PORTD, ACCESS	    ;move W to PORTD
	end