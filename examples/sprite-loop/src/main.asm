  ; Start at x=$20
  LDA #$10
  STA sprite_id
  LDA #$20
  STA sprite_pos

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

CreateSprite:
  LDX #$00
CreateSpriteLoop:
  LDA #$68
  STA $0200, x ; pos y
  LDA sprite_id
  STA $0201, x ; sprite id
  LDA #$00 
  STA $0202, x ; param
  LDA sprite_pos
  STA $0203, x ; pos x
  ; move 4 steps
  INX
  INX
  INX
  INX
  ; increment sprite_id
  INC sprite_id
  ; Move sprite_pos
  LDA sprite_pos
  ADC #$08
  STA sprite_pos
  ; loop 4 times
  CPX #$50            
  BNE CreateSpriteLoop

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer
  
  RTI        ; return from interrupt