  JSR LoadSlide1
  JSR LoadPalettes
  JSR LoadAttributes

EnableSprites:
  JSR RenderStart

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

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
  JSR Readjoy
  JSR Handlejoy
  JSR CheckBackground
  ; store last key
  LDA buttons 
  STA last_button

  RTI        ; return from interrupt

; Background ops

CheckBackground:
  LDA stage_to
  CMP stage_at
  BEQ CheckBackgroundDone
  STA stage_at
  JSR RenderStop
  JSR ChangeBackground
  JSR LoadPalettes
  JSR LoadAttributes
  JSR RenderStart
  
CheckBackgroundDone:
  RTS

ChangeBackground:
  LDA stage_at
  CMP #$00
  BEQ ChangeTo1
  CMP #$01
  BEQ ChangeTo2
  CMP #$02
  BEQ ChangeTo3
  CMP #$03
  BEQ ChangeTo4
  CMP #$04
  BEQ ChangeTo5
ChangeTo1:
  JSR LoadSlide1
  JSR LoadPalettes
  RTS
ChangeTo2:
  JSR LoadSlide2
  JSR LoadPalettes
  RTS
ChangeTo3:
  JSR LoadSlide3
  JSR LoadPalettes
  RTS
ChangeTo4:
  JSR LoadSlide4
  JSR LoadPalettes
  RTS
ChangeTo5:
  JSR LoadSlide5
  JSR LoadPalettes
  RTS
ChangeBackgroundDone:
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

LoadSlide1:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<slide1
  STA pointerBackgroundLowByte
  LDA #>slide1
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

LoadSlide2:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<slide2
  STA pointerBackgroundLowByte
  LDA #>slide2
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

LoadSlide3:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<slide3
  STA pointerBackgroundLowByte
  LDA #>slide3
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

LoadSlide4:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<slide4
  STA pointerBackgroundLowByte
  LDA #>slide4
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

LoadSlide5:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<slide5
  STA pointerBackgroundLowByte
  LDA #>slide5
  STA pointerBackgroundHighByte

  JSR UpdateBackground
  RTS

; Joypad

Readjoy:
    LDA #$01
    STA JOYPAD1
    STA buttons
    LSR a
    STA JOYPAD1
ReadjoyLoop:
    LDA JOYPAD1
    LSR a
    ROL buttons
    BCC ReadjoyLoop
    RTS

Handlejoy:
  LDA buttons
CheckButtonRepeat: ; don't fire multiple times
  CMP last_button
  BNE OnButton
  RTS
OnButton:
  CMP #$08
  BNE OnButtonUpDone
  INC stage_to
OnButtonUpDone:
  CMP #$04
  BNE OnButtonDownDone
  DEC stage_to
OnButtonDownDone:
  RTS

; Renderer

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