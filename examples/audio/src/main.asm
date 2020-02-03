; include "src/notes.asm"

PlaySound:
  ;Enable sound channels
  LDA #%00000111 
  STA $4015 ;enable Square 1, Square 2 and Triangle
  
  ;Square 1
  LDA #%00111000 ;Duty 00, Length Counter Disabled, Saw Envelopes disabled, Volume 8
  STA $4000
  LDA #$C9    ;0C9 is a C# in NTSC mode
  STA $4002   ;low 8 bits of period
  LDA #$00
  STA $4003   ;high 3 bits of period
  
  ;Square 2
  LDA #%01110110  ;Duty 01, Volume 6
  STA $4004
  LDA #$A9        ;$0A9 is an E in NTSC mode
  STA $4006
  LDA #$00
  STA $4007

  ;Triangle    
  LDA #$81    ;disable internal counters, channel on
  STA $4008
  LDA #$42    ;$042 is a G# in NTSC mode
  STA $400A
  LDA #$00
  STA $400B

Forever:
  JMP Forever     ;jump back to Forever, infinite loop
  
NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  ;;This is the PPU clean up section, so rendering the next frame starts properly.

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA $2005
  STA $2005
  
  RTI             ; return from interrupt