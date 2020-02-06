  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes

; set health to 8

  LDA #$24
  STA health

; sprite

DrawBit1:
  LDA #$1d
  STA $0200        ; set tile.y pos
  LDA #$01
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$08
  STA $0203        ; set tile.x pos

DrawBit2:
  LDA #$1d
  STA $0204        ; set tile.y pos
  LDA #$02
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  LDA #$10
  STA $0207        ; set tile.x pos

DrawBit3:
  LDA #$1d
  STA $0208        ; set tile.y pos
  LDA #$03
  STA $0209        ; set tile.id
  LDA #$00
  STA $020a        ; set tile.attribute
  LDA #$18
  STA $020b        ; set tile.x pos

DrawBit4:
  LDA #$1d
  STA $020c        ; set tile.y pos
  LDA #$03
  STA $020d        ; set tile.id
  LDA #$00
  STA $020e        ; set tile.attribute
  LDA #$20
  STA $020f        ; set tile.x pos

DrawBit5:
  LDA #$1d
  STA $0210        ; set tile.y pos
  LDA #$03
  STA $0211        ; set tile.id
  LDA #$00
  STA $0212        ; set tile.attribute
  LDA #$28
  STA $0213        ; set tile.x pos

DrawBit6:
  LDA #$1d
  STA $0214        ; set tile.y pos
  LDA #$03
  STA $0215        ; set tile.id
  LDA #$00
  STA $0216        ; set tile.attribute
  LDA #$30
  STA $0217        ; set tile.x pos

EnableSprites:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001
  BEQ ReadADone
  NOP             ; Do nothing..
ReadADone:
  
ReadB: 
  LDA $4016
  AND #%00000001
  BEQ ReadBDone
  NOP             ; Do nothing..
ReadBDone:

ReadSel: 
  LDA $4016
  AND #%00000001
  BEQ ReadSelDone 
  NOP             ; Do nothing..
ReadSelDone:

ReadStart: 
  LDA $4016
  AND #%00000001
  BEQ ReadStartDone 
  NOP             ; Do nothing..
ReadStartDone:

ReadUp: 
  LDA $4016
  AND #%00000001
  BEQ ReadUpDone 
  JSR IncreaseHealth
  JSR UpdateHealth
  JSR UpdateBar
ReadUpDone:

ReadDown: 
  LDA $4016
  AND #%00000001
  BEQ ReadDownDone 
  JSR DecreaseHealth
  JSR UpdateHealth
  JSR UpdateBar
ReadDownDone:

ReadLeft: 
  LDA $4016
  AND #%00000001
  BEQ ReadLeftDone 
  JSR DecreaseHealth
  JSR UpdateHealth
  JSR UpdateBar
ReadLeftDone:

ReadRight: 
  LDA $4016
  AND #%00000001
  BEQ ReadRightDone 
  JSR IncreaseHealth
  JSR UpdateHealth
  JSR UpdateBar
ReadRightDone:
  
  RTI             ; return from interrupt

; Tools

IncreaseHealth:
  LDA health
  CMP #$2a
  BCC DoIncrHealth
  RTS
DoIncrHealth:
  INC health
  RTS

DecreaseHealth:
  LDA health
  CMP #$21
  BCC DoDecrHealth
  DEC health
DoDecrHealth:
  RTS

; Draw subroutines

UpdateHealth:
  LDA health
  STA $0219        ; set tile.id
  RTS

UpdateBar:
  ; clear bar
  LDA #$00
  STA $0201
  STA $0205
  STA $0209
  STA $020d
  STA $0211
  STA $0215
  LDA health
DrawBar1:
  CMP #$21
  BCC DrawBar2
  LDX #$01
  STX $0201
DrawBar2:
  CMP #$23
  BCC DrawBar3
  LDX #$02
  STX $0205
DrawBar3:
  CMP #$25
  BCC DrawBar4
  LDX #$02
  STX $0209
DrawBar4:
  CMP #$27
  BCC DrawBar5
  LDX #$02
  STX $020d
DrawBar5:
  CMP #$29
  BCC DrawBar6
  LDX #$02
  STX $0211
DrawBar6:
  CMP #$2a
  BCC DrawDone
  LDX #$03
  STX $0215
DrawDone:
  RTS

; 

LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #<background ; Loading the #LOW(var) byte in asm6
  STA pointerBackgroundLowByte
  LDA #>background ; Loading the #HIGH(var) byte in asm6
  STA pointerBackgroundHighByte

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