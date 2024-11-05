	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	movwf	TRISD, A	    ; Port D set to 0, this is clock pulse
	movwf	LATC, A		    ; Set outout to 0
setup:
	movlw	0x5
	movwf	0x20, A
up_loop: 
	incf	LATC, F
	decf	0x20
	;call delay
	btfss	LATC, 2		    ; Check bit 2 is 1 if it is skip
	goto	up_loop
	
down_loop:
	decf	LATC, F
	;call delay
	btfss	LATC, 0		    ;check if value is 0
	goto	down_loop
	
loop:
	movff 	0x06, PORTB
	incf 	0x06, W, A
test:
	movwf	0x06, A	    ; Test for end of loop condition
	movlw 	0x63
	cpfsgt 	0x06, A
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
