	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	clrf	PORTD
	clrf	TRISD
	call	SPI_MasterInit
	call	SPI_MasterTransmit	
	
delay	nop
	nop
	nop
	nop
	nop
	return
	
SPI_MasterInit
	bcf	SSP2STAT, CKE
	movlw	(1<<SSPEN)|(1<<CKP)|(0x02)
	movwf	SSP2CON1
	bcf	TRISD, SDO2
	bcf	TRISD, SCK2
	return
	
SPI_MasterTransmit
	movlw	0x3a
	movwf	SSP2BUF
	call	delay
Wait_Transmit
	btfss	PIR2, SSP2IF
	call	delay
	bra	Wait_Transmit
	bcf	PIR2, SSP2IF
	return
end