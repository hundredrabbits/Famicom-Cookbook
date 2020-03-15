		
PPU0	EQU $2000
PPU1	EQU $2001

	IFNDEF NIJUU_ENGINE
NIJUU_ENGINE	EQU $8000
	ENDIF
	IFNDEF NIJUU_NEW_SONG
NIJUU_NEW_SONG	EQU $8003
	ENDIF

	ORG $FF00
RESET	sei
	jsr VBLANKWAIT
		
	;clear RAM
	lda #$00
	ldx #$00
_clear_ram_loop	sta $0000,x
	sta $0100,x
	sta $0200,x
	sta $0300,x
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	inx
	bne _clear_ram_loop

	ldx #$FF			;reset stack pointer
	txs

	lda #$00
	sta PPU0
	sta PPU1

	jsr INIT_GRAPHICS
	
	lda #$00		;init song 0
	jsr NIJUU_NEW_SONG	

	lda #%10001000
	sta PPU0
	lda #%00011110
	sta PPU1

MAIN_LOOP	jmp MAIN_LOOP
	
VBLANKWAIT	lda $2002
	bpl VBLANKWAIT
	rts

VBLANK	pha
	txa
	pha
	tya
	pha
	bit $2002

	ldy #$02		;delay to push CPU display down
	ldx #$00		; onto visible area of screen
_delay_loop	dex
	bne _delay_loop
	dey
	bne _delay_loop
	
	lda #%11111111		;make bg white
	sta $2001
	
	jsr NIJUU_ENGINE	;NIJUU_ENGINE

	lda #%11111110		;set bg back to black
	sta $2001

	pla
	tay
	pla
	tax
	pla
IRQ	rti

INIT_GRAPHICS	lda #$3f
	ldx #$00
	sta $2006
	stx $2006
_init_graphics	lda PALETTE,x
	sta $2007
	inx
	cpx #$20
	bne _init_graphics
	rts

PALETTE	HEX 3F 3F 3F 10 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F
	HEX 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F 3F

	ORG $FFFA
	DW VBLANK, RESET, IRQ
				