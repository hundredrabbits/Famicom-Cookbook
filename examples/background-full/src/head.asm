
;; VARIABLES

    .enum $0000                ; Zero Page variables
bg_lb                   .dsb 1
bg_hb                   .dsb 1
    .ende

;; CONSTANTS

PRG_COUNT       = 1            ; 1 = 16KB, 2 = 32KB
MIRRORING       = %0001
PPU_Control         .equ $2000
PPU_Mask            .equ $2001
PPU_Status          .equ $2002
PPU_Scroll          .equ $2005
PPU_Address         .equ $2006
PPU_Data            .equ $2007
spriteRAM           .equ $0200
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