  LDA #$88
  STA POS_X
  STA POS_Y

  JSR LoadLevelTown
  JSR LoadPalettes
  JSR LoadAttributes

CreatePlayerSprite:
  LDA #$88
  STA $0200        ; set tile.y pos
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$88
  STA $0203        ; set tile.x pos

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
  JSR CheckLevel
  JMP Forever     ;jump back to Forever, infinite loop

CheckLevel:
  LDA POS_AT
  CMP POS_TO
  BEQ CheckLevelDone
  LDA POS_TO
  STA POS_AT
  JSR LoadLevelCave
CheckLevelDone:
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

LoadLevelTown:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #$00
  STA pointerBackgroundLowByte
  LDA #$00
  STA pointerBackgroundHighByte

  LDA #<backgroundTown ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>backgroundTown ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

  LDX #$00
  LDY #$00
  JSR LoadBackgroundLoop
  RTS

LoadLevelCave:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #$00
  STA pointerBackgroundLowByte
  LDA #$00
  STA pointerBackgroundHighByte

  LDA #<backgroundCave ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>backgroundCave ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

  LDX #$00
  LDY #$00
  JSR LoadBackgroundLoop
  RTS

LoadBackgroundLoop:
  LDA (pointerBackgroundLowByte), y
  STA $2007
  INY
  CPY #$00
  BNE LoadBackgroundLoop
  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE LoadBackgroundLoop
  RTS

WhenPressUp:
  DEC POS_Y
  JSR Update
  LDA #$04
  STA SPRITE_ID
  RTS

WhenPressRight:
  INC POS_X
  JSR Update
  LDA #$05
  STA SPRITE_ID
  RTS

WhenPressDown:
  INC POS_Y
  JSR Update
  LDA #$07
  STA SPRITE_ID
  RTS

WhenPressLeft:
  DEC POS_X
  JSR Update
  LDA #$06
  STA SPRITE_ID
  RTS

WhenPressA:
  LDA #02
  STA POS_TO
  RTS

WhenPressB:
  LDA #01
  STA POS_TO
  RTS

Update:
  LDA POS_X
  STA SPRITE_X
  LDA POS_Y
  STA SPRITE_Y
  RTS
