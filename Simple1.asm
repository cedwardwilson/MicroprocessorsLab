	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0xff
	movwf	0x02, ACCESS
	movwf	TRISC, ACCESS	    ;set C to input
restart	movlw	0x0
	movwf	TRISD, ACCESS
	movwf	TRISE, ACCESS	    ;set E to output
	movwf	0x01, ACCESS	    ;store literal 99 decimal at address
	movff	0x01, PORTE
counter	incf	0x01, f, ACCESS
	movff	0x01, PORTE
	movf	0x01, W, ACCESS
	movf	PORTC, W, ACCESS
	movwf	PORTD, ACCESS
	cpfsgt	0x02, ACCESS
	bra	counter
	bra	counter
	
	end 