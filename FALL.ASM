; "Fall", Atari XL/XE Intro 64B
; (64 bytes of code + 6 bytes of header)
; code by tr1x / Agenda
; code of cosine wave generator by Koala / Agenda (support Ilmenit / Agenda)
; optimization by Koala / Agenda
; requirements: original Atari XL/XE 64KB PAL
; version: 1.0
; release date: 2022-02-12

coswav	equ $bc20			; overwrite dlist with cosine wave

rtclok	equ $0012
hposp0	equ $d000
sizep0	equ $d008
grafp0	equ $d00d
colpm0	equ $d012
vcount	equ $d40b


	org $0080

	jsr $dc50			; A=X=Y=0

	; generate cosine wave array
loop1
opcod1	adc #$00
	bvc skip0
	inc opcod3+1
skip0	inc opcod1+1
	inc opcod1+1
	pha
opcod3	lda #$00
adrcos	equ *+1
	sta coswav,x
	dey
	sta (adrcos),y
	pla
	inx
	bpl loop1

	; there is magic here
loop2	ldy rtclok+2
loop3	adc (adrcos),y
	ldx #$03
loop4	eor #$ff
opcode1	adc rtclok+2
	sta grafp0,x
adrhpos	equ *+1
	sta hposp0,x
	sta colpm0,x
	pha
	lda opcode1
	eor #%10000000			; change "adc" to "sbc", or "sbc" to "adc"
	sta opcode1
	pla
	dex
	bpl loop4
	iny
	lda vcount
	bne loop3
	beq loop2