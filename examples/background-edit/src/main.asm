; origins
  LDA #$88
  STA pos_x
  LDA #$88
  STA pos_y

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

CreateSprite:
  LDA pos_y
  STA $0200        ; set tile.y pos
  LDA #$01
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA pos_x
  STA $0203        ; set tile.x pos

CreateGui:
CreateGuiX:
  LDA #$20
  STA $0204        ; set tile.y pos
  LDA #$21
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  LDA #$20
  STA $0207        ; set tile.x pos
CreateGuiY:
  LDA #$20
  STA $0208        ; set tile.y pos
  LDA #$21
  STA $0209        ; set tile.id
  LDA #$00
  STA $020a        ; set tile.attribute
  LDA #$28
  STA $020b        ; set tile.x pos

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

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  LDA #$06        ; sprite tile
  STA $0201
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  LDA #$06        ; sprite tile
  STA $0201
ReadBDone:        ; handling this button is done

ReadSel: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelDone 
  LDA #$06        ; sprite tile
  STA $0201
ReadSelDone:        ; handling this button is done

ReadStart: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone 
  LDA #$06        ; sprite tile
  STA $0201
ReadStartDone:        ; handling this button is done

ReadUp: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone 
  DEC pos_y
  DEC pos_y
  JSR Update
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  INC pos_y
  INC pos_y
  JSR Update
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadLeftDone 
  DEC pos_x
  DEC pos_x
  JSR Update
ReadLeftDone:        ; handling this button is done

ReadRight: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadRightDone 
  INC pos_x
  INC pos_x
  JSR Update
ReadRightDone:        ; handling this button is done
  
  RTI             ; return from interrupt

Update:
  ; move X
  LDA pos_x ; load pos x
  STA $0203 ; set x pos
  STA tile_x
  LSR tile_x
  LSR tile_x
  LSR tile_x
  LSR tile_x
  LDA tile_x
  ADC #$20
  STA $0205
  ; move y
  LDA pos_y ; load pos y
  STA $0200 ; set y pos
  STA tile_y
  LSR tile_y
  LSR tile_y
  LSR tile_y
  LSR tile_y
  LDA tile_y
  ADC #$20
  STA $0209
  RTS