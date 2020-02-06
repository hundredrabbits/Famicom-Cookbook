  JSR LoadBackground1
  JSR LoadPalettes
  JSR LoadAttributes

EnableSprites:
  JSR RenderStart

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

CheckBackground:
  LDA is_rendering
  CMP #$01
  BEQ CheckBackgroundDone
  INC $10
CheckBackgroundDone:
  RTS

LoadBackground1:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<backgroundTown ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>backgroundTown ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

LoadBackground2:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<backgroundCave ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>backgroundCave ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

  JSR UpdateBackground
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
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  JSR RenderStart
ReadADone:        ; handling this button is done

ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  JSR RenderStop
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone
  INC $11
  JSR RenderStop
  JSR LoadBackground2
  JSR RenderStart
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  INC $12
  JSR RenderStop
  JSR LoadBackground1
  JSR RenderStart
ReadStartDone:        ; handling this button is done

  RTI        ; return from interrupt

RenderStart:
  LDA #$01
  STA is_rendering
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005
  RTS

RenderStop:
  LDA #$00
  STA is_rendering
  LDA #%10000000   ; disable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00000000   ; disable sprites
  STA $2001
  RTS

UpdateBackground:
  LDX #$00
  LDY #$00
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