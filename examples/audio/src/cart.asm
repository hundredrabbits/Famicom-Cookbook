
;; iNES HEADER

  .db  "NES", $1a              ; identification of the iNES header
  .db  PRG_COUNT               ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|MIRRORING           ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; CONSTANTS

PRG_COUNT       = 1            ; 1 = 16KB, 2 = 32KB
MIRRORING       = %0001
PPU_Control     .equ $2000
PPU_Mask        .equ $2001
PPU_Status      .equ $2002
PPU_Scroll      .equ $2005
PPU_Address     .equ $2006
PPU_Data        .equ $2007
spriteRAM       .equ $0200
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

;; main

PlaySound:                     ; include "src/notes.asm"
  ;Enable sound channels
  LDA #%00000111
  STA $4015                    ; enable Square 1, Square 2 AND Triangle
  ;Square 1
  LDA #%00111000               ; Duty 00, Length Counter Disabled, Saw Envelopes disabled, Volume 8
  STA $4000
  LDA #$C9                     ; 0C9 is a C# in NTSC mode
  STA $4002                    ; low 8 bits of period
  LDA #$00
  STA $4003                    ; high 3 bits of period
  ;Square 2
  LDA #%01110110               ; Duty 01, Volume 6
  STA $4004
  LDA #$A9                     ; $0A9 is an E in NTSC mode
  STA $4006
  LDA #$00
  STA $4007
  ;Triangle    
  LDA #$81                     ; disable internal counters, channel on
  STA $4008
  LDA #$42                     ; $042 is a G# in NTSC mode
  STA $400A
  LDA #$00
  STA $400B

;;

Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer

;;This is the PPU clean up section, so rendering the next frame starts properly.

  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110               ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00                     ; 
  STA $2005
  STA $2005
  RTI                          ; return from interrupt

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; sprites

  .incbin "src/sprite.chr"