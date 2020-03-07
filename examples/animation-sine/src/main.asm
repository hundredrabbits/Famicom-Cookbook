
;;

LoadPalettes:                  ; 
  LDA $2002                    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006                    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006                    ; write the low byte of $3F00 address
  LDX #$00
LoadPalettesLoop:              ; 
  LDA palette, x               ; load palette byte
  STA $2007                    ; write to PPU
  INX                          ; set index to next byte
  CPX #$20
  BNE LoadPalettesLoop         ; if x = $20, 32 bytes copied, all done

;;

DrawSprite1:                   ; 
  LDA #$88
  STA $0200                    ; set tile.y pos
  LDA #$05
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
DrawSprite2:                   ; 
  LDA #$88
  STA $0204                    ; set tile.y pos
  LDA #$06
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$80
  STA $0207                    ; set tile.x pos
  LDA #%10000000               ; enable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
  JSR animate
  RTI                          ; return from interrupt
animate:                       ; 
  LDX $00
  LDA sin, x
  CLC
  ADC #$30
  STA $0207
  INC $00
  LDA $00
  CMP #$40
  BNE animateDone
  LDA #$00
  STA $00
animateDone:                   ; 
  RTS