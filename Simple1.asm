	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0xff
	movwf	TRISD, ACCESS
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x10, PORTC
	incf 	0x10, W, ACCESS
test	movwf	0x10, ACCESS	    ; Test for end of loop condition
	movlw	0x32
	;movf	PORTD, W, ACCESS
	cpfsgt 	0x10, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
	end
