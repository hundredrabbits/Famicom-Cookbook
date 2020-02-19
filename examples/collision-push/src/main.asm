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
  BNE LoadPalettesLoop  

SetOriginalPosition:
  LDA #$40
  STA pos_x
  STA pos_y
  LDA #$56
  STA box_pos_x
  STA box_pos_y
  JSR Update

CreateSprite:
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute

CreateBox1:
  LDA #$09
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  
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
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  NOP ; Nothing to do..
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  NOP ; Nothing to do..
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone 
  NOP ; Nothing to do..
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  NOP ; Nothing to do..
ReadStartDone:        ; handling this button is done

ReadUp: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone 
  DEC pos_y
  LDA #$01        ; sprite tile
  STA $0201
  JSR Update
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  INC pos_y
  LDA #$02        ; sprite tile
  STA $0201
  JSR Update
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadLeftDone 
  DEC pos_x
  LDA #$03        ; sprite tile
  STA $0201
  JSR Update
ReadLeftDone:        ; handling this button is done

ReadRight: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadRightDone 
  INC pos_x
  LDA #$04        ; sprite tile
  STA $0201
  JSR Update
ReadRightDone:        ; handling this button is done
  
  ;;This is the PPU clean up section, so rendering the next frame starts properly.

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA $2005
  STA $2005
  
  RTI             ; return from interrupt

;

Update:
  JSR TestCollision
  JSR RunCollision
  JSR UpdatePlayer
  JSR UpdateBox
  RTS

UpdatePlayer:
  LDA pos_y
  STA $0200
  LDA pos_x
  STA $0203
  RTS

UpdateBox:
  LDA box_pos_y
  STA $0204        ; set tile.y pos
  LDA box_pos_x
  STA $0207        ; set tile.x pos
  LDA is_colliding
  CMP #$01
  BNE UpdateBoxIcon1
  JSR UpdateBoxIcon2
  RTS

UpdateBoxIcon1:
  LDA #$09
  STA $0205
  RTS

UpdateBoxIcon2:
  LDA #$0a
  STA $0205
  RTS

TestCollision:
  LDA #$00
  STA is_colliding
  LDA pos_x ; x1 
  CLC
  ADC #$06  ; x1 + w (16)
  CMP box_pos_x ; x2
  BMI TestCollisionDone
  LDA box_pos_x ; x2
  CLC
  ADC #$06  ; x2 + w (16)
  CMP pos_x
  BMI TestCollisionDone
  LDA pos_y ; y1
  CLC
  ADC #$06  ; y1 + h (16)
  CMP box_pos_y
  BMI TestCollisionDone
  LDA box_pos_y ; y2
  CLC
  ADC #$06  ; y2 + h (16)
  CMP pos_y
  BMI TestCollisionDone
  LDA #$01
  STA is_colliding
TestCollisionDone:
  RTS

RunCollision:
  LDA is_colliding
  CMP #$01
  BNE RunCollisionDone
RunCollisionUp:
  LDA pos_y
  ADC #$04
  CMP box_pos_y
  BCS RunCollisionDown
  INC box_pos_y
RunCollisionDown:
  LDA pos_y
  SBC #$04
  CMP box_pos_y
  BCC RunCollisionRight
  DEC box_pos_y
RunCollisionRight:
  LDA pos_x
  ADC #$04
  CMP box_pos_x
  BCS RunCollisionLeft
  INC box_pos_x
RunCollisionLeft:
  LDA pos_x
  SBC #$04
  CMP box_pos_x
  BCC RunCollisionDone
  DEC box_pos_x
RunCollisionDone:
  RTS