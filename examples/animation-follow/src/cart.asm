
;; iNES HEADER

  .db  "NES", $1a              ; identification of the iNES header
  .db  PRG_COUNT               ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|MIRRORING           ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; VARIABLES

  .enum $0000                  ; Zero Page variables
pos_x .dsb 1
pos_y .dsb 1
  .ende

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

;;  RESET

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

;; palette

LoadPalettes:                  ; 
  LDA $2002                    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006                    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006                    ; write the low byte of $3F00 address
  LDX #$00                     ; start out at 0
LoadPalettesLoop:              ; 
  LDA palette, x               ; load data from address (palette + the value in x)
  STA $2007                    ; write to PPU
  INX                          ; X = X + 1
  CPX #$20                     ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  

;; sprite

CreateSprite:                  ; 
  LDA #$88
  STA $0200                    ; set tile.y pos
  LDA #$05
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
CreateFollower:                ; 
  LDA #$88
  STA $0204                    ; set tile.y pos
  LDA #$05
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$88
  STA $0207                    ; set tile.x pos

;; enable sprites

  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever                  

;; nmi

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer

;; update

  JSR updateFollower

;; controls

LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
ReadA:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadADone
  LDA #$06                     ; sprite tile
  STA $0201
ReadADone:                     ; handling this button is done
ReadB:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  LDA #$06                     ; sprite tile
  STA $0201
ReadBDone:                     ; handling this button is done
ReadSel:                       ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone 
  LDA #$06                     ; sprite tile
  STA $0201
ReadSelDone:                   ; handling this button is done
ReadStart:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone 
  LDA #$06                     ; sprite tile
  STA $0201
ReadStartDone:                 ; handling this button is done
ReadUp:                        ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone 
  DEC $0200
  DEC $0200
  LDA #$01                     ; sprite tile
  STA $0201
ReadUpDone:                    ; handling this button is done
ReadDown:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone 
  INC $0200
  INC $0200
  LDA #$02                     ; sprite tile
  STA $0201
ReadDownDone:                  ; handling this button is done
ReadLeft:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadLeftDone 
  DEC $0203
  DEC $0203
  LDA #$03                     ; sprite tile
  STA $0201
ReadLeftDone:                  ; handling this button is done
ReadRight:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadRightDone 
  INC $0203
  INC $0203
  LDA #$04                     ; sprite tile
  STA $0201
ReadRightDone:                 ; handling this button is done
  RTI                          ; return from interrupt

;;

updateFollower:                ; 
  JSR updateFollowerX
  JSR updateFollowerY
  RTS

;; x

updateFollowerX:               ; 
  LDA $0207                    ; follower x
  CMP $0203                    ; sprite x
  BEQ updateFollowerXDone
  BCC updateFollowerXINC
  DEC $0207
  RTS
updateFollowerXINC:            ; 
  INC $0207
updateFollowerXDone:           ; 
  RTS

;; y

updateFollowerY:               ; 
  LDA $0204                    ; follower x
  CMP $0200                    ; sprite x
  BEQ updateFollowerYDone
  BCC updateFollowerYINC
  DEC $0204
  RTS
updateFollowerYINC:            ; 
  INC $0204
updateFollowerYDone:           ; 
  RTS

;; tables

palette:                       ; 
  .db $0F,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$0F
  .db $0F,$3B,$15,$0F,$0F,$02,$0F,$0F,$0F,$1C,$15,$14,$31,$02,$38,$3C

;; Vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; sprite

  .incbin "src/sprite.chr"