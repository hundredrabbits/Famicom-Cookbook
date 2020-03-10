
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
  .ende

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
@vwait1:                       ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL @vwait1                  ; at this point, about 27384 cycles have passed
@vwait2:                       ; Second wait for vblank, PPU is ready after this
  INX
  BNE @noincy
  INY
@noincy:                       ; 
  BIT $2002
  BPL @vwait2                  ; at this point, about 57165 cycles have passed

;;

; BUT because of a hardware oversight, we might have missed a vblank flag.
; so we need to both check for 1Vbl AND 2Vbl
; NTSC NES: 29780 cycles / 12.005 -> $9B0 or $1361 (Y:X)
; PAL NES:  33247 cycles / 12.005 -> $AD1 or $15A2
; Dendy:    35464 cycles / 12.005 -> $B8A or $1714
  TYA
  CMP #16
  BCC @nodiv2
  LSR
@nodiv2:                       ; 
  CLC
  ADC #<-9
  CMP #3
  BCC @noclip3
  LDA #3
@noclip3:                      ; 

;;; Right now, A contains 0,1,2,3 for NTSC,PAL,Dendy,Bad

  STA $00

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

;;

Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
  RTI                          ; return from interrupt

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