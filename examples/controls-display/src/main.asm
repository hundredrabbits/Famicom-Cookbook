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

SetBitPosY:
  LDA #$60
  STA $0200
  STA $0204
  STA $0208
  STA $020c
  STA $0210
  STA $0214
  STA $0218
  STA $021c

SetBitTileAttr:
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e
  STA $0212
  STA $0216
  STA $021a
  STA $021e

SetBitPosX:
  LDA #$20
  STA $0203
  LDA #$28
  STA $0207
  LDA #$30
  STA $020b
  LDA #$38
  STA $020f
  LDA #$40
  STA $0213
  LDA #$48
  STA $0217
  LDA #$50
  STA $021b
  LDA #$58
  STA $021f

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

ClearPressed:
  LDA #$00
  STA up_pressed
  STA a_pressed
  STA b_pressed
  STA sel_pressed
  STA start_pressed
  STA up_pressed
  STA down_pressed
  STA left_pressed
  STA right_pressed 

ClearTileId:
  LDA #$20
  STA $0201
  STA $0205
  STA $0209
  STA $020d
  STA $0211
  STA $0215
  STA $0219
  STA $021d

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  LDA #$01
  STA a_pressed
  JSR Update
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  LDA #$01
  STA b_pressed
  JSR Update
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone 
  LDA #$01
  STA sel_pressed
  JSR Update
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  LDA #$01
  STA start_pressed
  JSR Update
ReadStartDone:        ; handling this button is done

ReadUp: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone 
  LDA #$01
  STA up_pressed
  JSR Update
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  LDA #$01
  STA down_pressed
  JSR Update
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadLeftDone 
  LDA #$01
  STA left_pressed
  JSR Update
ReadLeftDone:        ; handling this button is done

ReadRight: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadRightDone 
  LDA #$01
  STA right_pressed
  JSR Update
ReadRightDone:        ; handling this button is done
  
  RTI             ; return from interrupt

Update:
DrawBit1:
  LDA a_pressed
  CMP #$01
  BNE DrawBit2
  LDA #$21
  STA $0201
DrawBit2:
  LDA b_pressed
  CMP #$01
  BNE DrawBit3
  LDA #$21
  STA $0205
DrawBit3:
  LDA sel_pressed
  CMP #$01
  BNE DrawBit4
  LDA #$21
  STA $0209
DrawBit4:
  LDA start_pressed
  CMP #$01
  BNE DrawBit5
  LDA #$21
  STA $020d
DrawBit5:
  LDA up_pressed
  CMP #$01
  BNE DrawBit6
  LDA #$21
  STA $0211
DrawBit6:
  LDA down_pressed
  CMP #$01
  BNE DrawBit7
  LDA #$21
  STA $0215
DrawBit7:
  LDA left_pressed
  CMP #$01
  BNE DrawBit8
  LDA #$21
  STA $0219
DrawBit8:
  LDA right_pressed
  CMP #$01
  BNE DrawDone
  LDA #$21
  STA $021d
DrawDone:
  RTS