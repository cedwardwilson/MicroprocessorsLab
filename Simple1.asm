	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x01
	movwf	0x04, ACCESS
	movlw	0xFE		    ;literal 254 onto W
	movwf	0x03, ACCESS	    ;store 254 in address
	movlw	0x0		    
	movwf	0x02, ACCESS	    ;store 0 in address
	movwf	TRISC, ACCESS	    ;set Port C to outputs
	lfsr	FSR0, 0x110	    ;load FSR0 with address (12-bit)
loop	movf	0x02, W, ACCESS	    ;move literal in address to W
	movwf	POSTINC0	    ;move W into FRS0 address, increase address 
	incf	0x02, f, ACCESS	    ;increase literal at address 
	movf	0x03, W		    ;move 254 into W
	cpfsgt	0x02, ACCESS	    ;compare 254 to 0x02 value
	bra	loop		    ;will branch if 0x02 < 254
read	lfsr	FRS1, 0x20E	    ;load address into FSR1
	movf	POSTDEC1, W, ACCESS ;move FSR1 onto W and decrease FRS1 address
	movwf	PORTC		    ;move W onto Port C (LEDs)
	cpfslt	0x04, ACCESS	    ;compare W to 1 (literal stored at address)
	bra	read
	end