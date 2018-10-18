	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0x10		    ;Define datum for flipflop A
	movwf	0x01		    ;Address datum for A  
	movlw	0x81		    ;Define datum for flipflop B
	movwf	0x02		    ;Address datum for B
	clrf	PORTC
	clrf	PORTH
	clrf	TRISD		    ;Setting PORTD to output
	clrf	TRISE		    ;Setting PORTE to output
	clrf	TRISC
	clrf	TRISH
	movlw	0xC0		    ;Sets OE* to high for A and B (turns off)
	movwf	PORTD
	bra	write

delay	nop			    ;delays the CLK whilst it's high
	nop
	return

EInput	
	banksel	PADCFG1
	bsf	PADCFG1, REPU, BANKED	;sets pull up resistors on PORTE
	movlb	0x0		    ;resets BSR to 0
	setf	TRISE		    ;sets PORTE to input
	return
		
write	movff	0x01, PORTE	    ;give PORTE a value
	movlw	0xC1		    ;sets OE* and CLK to high 
	movwf	PORTD
	call	delay		    ;clock delay
	movlw	0xC0		    ;sets OE* to high and turns off CLK
	;call	delay
	movwf	PORTD
	;call	delay
	movff	0x02, PORTE
	movlw	0xC2
	call	delay
	movwf	PORTD
	call	delay		    ;clock delay
	movlw	0xC0
	call	delay
	movwf	PORTD
	call	delay
	call	EInput
	;movlw	0x0		    ;turns OE* off
	;movwf	PORTD		    ;moves data on A to PORTE
	;bra	read

read	movlw	0x80
	movwf	PORTD
	call	delay
	movf	PORTE, W	    ;move PORTE data to W
	call	delay
	movwf	PORTC
	movlw	0x40		    ;sets OE* to high
	movwf	PORTD
	call	delay
	movf	PORTE, W
	movwf	PORTH
	
	;call	delay
		                          
stop	
	bra	stop
	end