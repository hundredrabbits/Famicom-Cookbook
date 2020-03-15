
;; This example has no visuals, look at the zero-page to see the results.

;; ines header

  .db  "NES", $1a              ; identification of the iNES header
  .db  1                       ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|%0001               ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;;

  .org $C000

;; reset

__RESET:                       ; 
  SEI                          ; disable IRQs
  CLD                          ; disable decimal mode
  LDX #$40
  STX $4017                    ; disable APU frame IRQ
  LDX #$FF
  TXS                          ; Set up stack
  INX                          ; now X = 0
  STX $2000                    ; disable NMI
  STX $2001                    ; disable rendering
  STX $4010                    ; disable DMC IRQs
vblankwait1:                   ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1
clrmem:                        ; 
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x                 ; move all sprites off screen
  INX
  BNE clrmem
vblankwait2:                   ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2

;;

LoadPalettes:                  ; 
  LDA $2002                    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006                    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006                    ; write the low byte of $3F00 address
  LDX #$00
@loop:                         ; 
  LDA palette, x               ; load palette byte
  STA $2007                    ; write to PPU
  INX                          ; set index to next byte
  CPX #$20
  BNE @loop                    ; if x = $20, 32 bytes copied, all done

;; Masking

  ; 0 | 0000 | 4 | 0100 | 8 | 1000 | C | 1100
  ; 1 | 0001 | 5 | 0101 | 9 | 1001 | D | 1101
  ; 2 | 0010 | 6 | 0110 | A | 1010 | E | 1110
  ; 3 | 0011 | 7 | 0111 | B | 1011 | F | 1111

;; AND | To set individual bits to 0. 0->1=0 0->0=0 1->0=0 1->1=1

  LDA #%00110000               ; res | #$30
  AND #%01010000               ; res | #$10
  ;     00010000
  STA $00

;; ORA | To set individual bits to 1. 0->1=1 0->0=0 1->0=1 1->1=1

  LDA #%00110000               ; res | #$30
  ORA #%01010000               ; res | #$70
  ;     01110000
  STA $01

;; EOR | To invert individual bits. 0->1=1 0->0=0 1->0=1 1->1=0

  LDA #%00110000               ; res | #$30
  EOR #%01010000               ; res | #$60
  ;     01100000
  STA $02

;; BIT | To test the state of bits in a byte.(TODO)

  LDA #%00100001
  BIT #%00100001
  BEQ @isSet
  LDA #$00
  JMP @done
@isSet:                        ; 
  LDA #$01
@done:                         ; 
  STA $10


 ; LDA #$08
 ; BIT FLAGS
 ; BNE Bit3IsSet
 ; BEQ Bit3isClear


;;

__MAIN:                        ; 
  JMP __MAIN

;;

__NMI:                         ; 
  RTI

;; TABLES

  .org $E000

;;

palette:                       ; 
  .db $0F,$0F,$0F,$0F,  $0F,$20,$20,$0F,  $0F,$20,$0F,$20,  $0F,$20,$20,$20; background palette
  .db $0F,$27,$17,$07,  $0F,$20,$10,$00,  $0F,$1C,$15,$14,  $0F,$02,$38,$3C; sprite palette
sin:                           ; 
  .db $40,$46,$4c,$52,$58,$5e,$63,$68,$6d,$71,$75,$78,$7b,$7d
  .db $7e,$7f,$80,$7f,$7e,$7d,$7b,$78,$75,$71,$6d,$68,$63,$5e
  .db $58,$52,$4c,$46,$47,$3a,$34,$2e,$28,$22,$1d,$18,$13,$0f
  .db $0b,$08,$05,$03,$02,$01,$00,$01,$02,$03,$05,$08,$0b,$0f
  .db $13,$18,$1d,$22,$28,$2e,$34,$3a

;; vectors

  .pad $FFFA
  .dw __NMI
  .dw __RESET
  .dw 0