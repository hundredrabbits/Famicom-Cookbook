
;; ines header

  .db  "NES", $1a              ; identification of the iNES header
  .db  PRG_COUNT               ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|MIRRORING           ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; constants

PRG_COUNT       = 1            ; 1 = 16KB, 2 = 32KB
MIRRORING       = %0001
PPU_Control         .equ $2000
PPU_Mask            .equ $2001
PPU_Status          .equ $2002
PPU_Scroll          .equ $2005
PPU_Address         .equ $2006
PPU_Data            .equ $2007
spriteRAM           .equ $0200

;;

  .org $C000

;; reset

RESET:                         ; 
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

;;

DrawSprite1:                   ; 
  LDA #$88
  STA $0200                    ; set tile.y pos
  LDA #$05
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
DrawSprite2:                   ; 
  LDA #$88
  STA $0204                    ; set tile.y pos
  LDA #$06
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$80
  STA $0207                    ; set tile.x pos
  LDA #%10000000               ; enable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
  JSR animate
  RTI                          ; return from interrupt

;;

animate:                       ; 
  ; reg $10 position
  ; reg $11 direction
@flip                          ; load pos, compare with min/max, flip sprite
  LDA $10                      ; 
  CMP #$20                     ; min
  BEQ @flipright
  CMP #$50                     ; max
  BEQ @flipleft
  JMP @move
@flipright:                    ; 
  LDA #$01
  STA $11
  JMP @move
@flipleft:                     ; 
  LDA #$00
  STA $11
@move:                         ; move pos base on direction
  LDA $11                      ; load direction
  CMP #$01
  BEQ @inc
@movedec:                          ; 
  DEC $10
  JMP @done
@moveinc:                          ; 
  INC $10
@done:                         ; 
  LDA $10                      ; load pos
  STA $0207                    ; write sprite
  RTS

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
  .dw NMI
  .dw RESET
  .dw 0

;; sprite

  .incbin "src/sprite.chr"