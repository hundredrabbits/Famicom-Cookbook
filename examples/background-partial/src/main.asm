  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes

EnableSprites:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

LoadBackground:
  
  LDA $2000 ; read PPU status to reset the high/low latch
  LDA #$21
  STA $2006 ; write the high byte of $2000 address
  LDA #$04
  STA $2006 ; write the low byte of $2000 address

  STX #$00

LoadCardLoop:
  LDA card, x        ; load data from address (sprites +  x)
  STA $2007                ; X = X + 1
  INX
  CPX #$08              ; Compare X to hex $20, decimal 32
  BNE LoadCardLoop

  RTS

LoadPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
LoadPalettesLoop:
  LDA palettes, x
  STA $2007
  INX
  CPX #$20
  BNE LoadPalettesLoop
  RTS

LoadAttributes:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributesLoop:
  LDA attributes, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributesLoop
  RTS

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer
  
  RTI             ; return from interrupt