
  ; adding some values in the zeropage to be observable in the debugger

  LDA #$01
  STA $00
  LDA #$e2
  STA $01
  LDA #$f5
  STA $0f
  LDA #$84
  STA $07

  LDA #$33
  STA $10
  LDA #$2f
  STA $23
  LDA #$35
  STA $37
  LDA #$18
  STA $4b

LoadPalettes:
  LDA $2002    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006    ; write the low byte of $3F00 address
  LDX #$00

LoadPalettesLoop:
  LDA palette, x        ;load palette byte
  STA $2007             ;write to PPU
  INX                   ;set index to next byte
  CPX #$20            
  BNE LoadPalettesLoop  ;if x = $20, 32 bytes copied, all done

DrawSprite1:
  LDA #$88
  STA $0200        ; set tile.y pos
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$38
  STA $0203        ; set tile.x pos

DrawSprite2:
  LDA #$88
  STA $0204        ; set tile.y pos
  LDA #$06
  STA $0205        ; set tile.id
  LDA #$00
  STA $0206        ; set tile.attribute
  LDA #$40
  STA $0207        ; set tile.x pos

DrawSprite3:
  LDA #$88
  STA $0208        ; set tile.y pos
  LDA #$06
  STA $0209        ; set tile.id
  LDA #$00
  STA $020a        ; set tile.attribute
  LDA #$48
  STA $020b        ; set tile.x pos

DrawSprite4:
  LDA #$88
  STA $020c        ; set tile.y pos
  LDA #$06
  STA $020d        ; set tile.id
  LDA #$00
  STA $020e        ; set tile.attribute
  LDA #$50
  STA $020f        ; set tile.x pos

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop