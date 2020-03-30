
;; iNES header

  .db  "NES", $1a              ; identification of the iNES header
  .db  1                       ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|%0001               ; mapper 7
  .dsb $09,$00                 ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;; constants

PPUCTRL             .equ $2000
PPUMASK             .equ $2001
PPUSTATUS           .equ $2002 ; Using BIT PPUSTATUS preserves the previous contents of A.
SPRADDR             .equ $2003
PPUSCROLL           .equ $2005
PPUADDR             .equ $2006
PPUDATA             .equ $2007
SPRDMA              .equ $4014
SNDCHN              .equ $4015
JOY1                .equ $4016
JOY2                .equ $4017

;;

BUTTON_A            .equ #$80
BUTTON_B            .equ #$40
BUTTON_SELECT       .equ #$20
BUTTON_START        .equ #$10
BUTTON_UP           .equ #$08
BUTTON_DOWN         .equ #$04
BUTTON_LEFT         .equ #$02
BUTTON_RIGHT        .equ #$01

;;

  .enum $0000    

;;

down@input              .dsb 1
last@input              .dsb 1
next@input              .dsb 1

;;

  .ende