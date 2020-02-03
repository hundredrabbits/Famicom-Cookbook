; set health to 8

  LDA #$24
  STA health

; palette

LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0

LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero

; sprite

DrawBit1:
  LDA #$0f
  STA $0200        ; set tile.y pos
  LDA #$01
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$08
  STA $0203        ; set tile.x pos

DrawBit2:
  LDA #$0f
  STA $0204        ; set tile.y pos
  LDA #$02
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  LDA #$10
  STA $0207        ; set tile.x pos

DrawBit3:
  LDA #$0f
  STA $0208        ; set tile.y pos
  LDA #$03
  STA $0209        ; set tile.id
  LDA #$00
  STA $020a        ; set tile.attribute
  LDA #$18
  STA $020b        ; set tile.x pos

DrawBit4:
  LDA #$0f
  STA $020c        ; set tile.y pos
  LDA #$03
  STA $020d        ; set tile.id
  LDA #$00
  STA $020e        ; set tile.attribute
  LDA #$20
  STA $020f        ; set tile.x pos

DrawBit5:
  LDA #$0f
  STA $0210        ; set tile.y pos
  LDA #$03
  STA $0211        ; set tile.id
  LDA #$00
  STA $0212        ; set tile.attribute
  LDA #$28
  STA $0213        ; set tile.x pos

DrawBit6:
  LDA #$0f
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