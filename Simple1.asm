	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0x51		    ;Define datum for flipflop A
	movwf	0x01		    ;Address datum for A  
	movlw	0xaa		    ;Define datum for flipflop B
	movwf	0x02		    ;Address datum for B
	clrf	TRISD		    ;Setting PORTD to output
	clrf	TRISE		    ;Setting PORTE to output
	clrf	TRISC
	movlw	0x40		    ;Sets OE* to high for A which turns OE off
	movwf	PORTD
	bra	write

delay	nop			    ;delays the CLK whilst it's high
	nop
	return

EInput	bsf	PADCFG1, REPU, BANKED	;sets pull up resistors on PORTE
	movlb	0x0		    ;resets BSR to 0
	setf	TRISE		    ;sets PORTE to input
	return
		
write	movff	0x01, PORTE	    ;give PORTE a value
	movlw	0x41		    ;sets OE* and CLK to high 
	movwf	PORTD
	call	delay		    
	movlw	0x40		    ;sets OE* to high and turns off CLK
	movwf	PORTD
	call	EInput
	movlw	0x0		    ;turns OE* off
	movwf	PORTD		    ;moves data on A to PORTE
	bra	read

read	movf	PORTE, W	    ;move PORTE data to W
	movwf	PORTC
	movlw	0x40		    ;sets OE* to high
	movwf	PORTD
	call	delay
		                          
stop	
						    	bra	stop
	end