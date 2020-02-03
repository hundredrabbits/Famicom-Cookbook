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
  LDA #$88
  STA $0200        ; set tile.y pos
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$88
  STA $0203        ; set tile.x pos

CreateMarker:
  LDA #$30
  STA $0204        ; set tile.y pos
  LDA #$05
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  LDA #$58
  STA $0207        ; set tile.x pos

CreateMarkerX:
  LDA #$30
  STA $0208        ; set tile.y pos
  LDA #$05
  STA $0209        ; set tile.id
  LDA #$00
  STA $020a        ; set tile.attribute
  LDA #$60
  STA $020b        ; set tile.x pos

CreateMarkerY:
  LDA #$30
  STA $020c        ; set tile.y pos
  LDA #$05
  STA $020d        ; set tile.id
  LDA #$00
  STA $020e        ; set tile.attribute
  LDA #$68
  STA $020f        ; set tile.x pos

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001
            
; background

LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0

; screen segment 1/4

LoadBackgroundLoop:
  LDA background, x     ; load data from address (background + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$00              ; Each background table row is $10 in length
  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero

  LDX #$00

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
  DEC $0200
  LDA #$01        ; sprite tile
  STA $0201
  JSR UpdateMarker
ReadUpDone:        ; handling this button is done

ReadDown: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone 
  INC $0200
  LDA #$02        ; sprite tile
  STA $0201
  JSR UpdateMarker
ReadDownDone:        ; handling this button is done

ReadLeft: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadLeftDone 
  DEC $0203
  LDA #$03        ; sprite tile
  STA $0201
  JSR UpdateMarker
ReadLeftDone:        ; handling this button is done

ReadRight: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadRightDone 
  INC $0203
  LDA #$04        ; sprite tile
  STA $0201
  JSR UpdateMarker
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

UpdateMarker:
  LDA #$08        ; sprite tile
  STA $0205
  LDA #$06        ; sprite tile
  STA $0209
  STA $020d
  JSR TestX
  JSR TestY
  JSR TestXY
UpdateDone:
  RTS

; X is smaller than 48 and bigger than 12

TestX:
  LDA $0203 ; load x pos
  CMP #$48  ; less than 48
  BCC TestXPass
  JMP TestXDone
TestXPass:
  CMP #$18  ; more than 12
  BCC TestXDone
  LDA #$05
  STA $0209
TestXDone:
  RTS

; Y is smaller than 38 and bigger than 08

TestY:
  LDA $0200 ; load x pos
  CMP #$38  ; less than 38
  BCC TestYPass
  JMP TestYDone
TestYPass:
  CMP #$08  ; more than 08
  BCC TestYDone
  LDA #$05
  STA $020d
TestYDone:
  RTS

; spriteX is equal to spriteY and is not equal to 08

TestXY:
  LDA $0209 ; load X sprite
  CMP $020d ; compare with y sprite
  BEQ TestXYPass
  JMP TestXYDone
TestXYPass:
  CMP #$05
  BNE TestXYDone
  LDA #$07
  STA $0205
TestXYDone:
  RTS