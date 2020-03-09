
;; This examples has no visuals, inspect the zeropage memory to monitor changes.

;;  iNES HEADER

  .db  "NES", $1a              ; identification of the iNES header
  .db  1                       ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|%0001               ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; VARIABLES

  .enum $0000                  ; Zero Page variables
input_timer             .dsb 1
deck_len                .dsb 1
hand                    .dsb 1
  .ende

;; CONSTANTS

PPU_Control         .equ $2000
PPU_Mask            .equ $2001
PPU_Status          .equ $2002
PPU_Scroll          .equ $2005
PPU_Address         .equ $2006
PPU_Data            .equ $2007
spriteRAM           .equ $0200

;;

  .org $C000

;; RESET

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

;; start render

  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; let's do it

  JSR InitDeck

;;

Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
checkInputLock:                ; 
  LDA input_timer
  CMP #$00
  BEQ LatchController
  DEC input_timer
  RTI

;;

LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
@a:                            ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ @b
  JSR takeCard
  JSR lockInput
@b:                            ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ @done
  JSR putCard
  JSR lockInput
@done:                         ; handling this button is done
  RTI                          ; return from interrupt

;; Deck: Create a deck of 54($36) cards, from zeropage $40

InitDeck:                      ; 
  ; set deck length
  LDA #$35
  STA deck_len
  LDX #$00
@loop:                         ; 
  TXA
  STA $40, x
  INX
  CPX #$36
  BNE @loop
  RTS

;; take last card from the deck

takeCard:                      ; 
  LDA $40
  STA hand
  JSR shiftDeck
  RTS

;; put last card back into the deck

putCard:                       ; 
  ; check if has card in hand
  LDA hand
  CMP #$00
  BEQ @done                    ; no card to return
  ; return card
  LDX deck_len
  INX
  STA $40,x
  INC deck_len
  ; empty hand
  LDA #$00
  STA hand
@done
  RTS

;;

shiftDeck:                     ; 
  DEC deck_len
  LDX #$00
@loop:                         ; 
  TXA
  TAY
  INY
  LDA $40, y
  STA $40, x
  INX
  CPX #$36
  BNE @loop
@done
  RTS
lockInput:                     ; 
  LDA #$06
  STA input_timer
  RTS

;; tables

  .org $E000

;;

palette:                       ; 
  .db $0F,$2D,$16,$2D, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F
  .db $0F,$10,$17,$07, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0