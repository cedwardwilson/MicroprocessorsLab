#include p18f87k22.inc
	
	code
	org 0x01
	goto	start
	
	org 0x101

start
	movlw	0xFE
	movwf	0x03, ACCESS
	movlw	0x0
	movwf	0x02, ACCESS	
	lfsr	FSR0, 0x110 
loop	movf	0x02, W, ACCESS
	movwf	POSTINC0
	incf	0x02, ACCESS
	cpfsgt	0x03, ACCESS
	bra	loop
	end
	


