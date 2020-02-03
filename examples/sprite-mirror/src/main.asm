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

;; Anything that moves separately from the background will be made of sprites. 
;; A sprite is an 8x8 pixel tile that the PPU renders anywhere on the screen.
;; Generally, objects are made from multiple sprites next to each other.
;; The PPU has enough internal memory for 64 sprites.
;; SPRITE DATA
;; Each sprite needs 4 bytes of data for its position and tile information in this order:
;;
;; 1 | Y Position  | $00 = top of screen, $EF = bottom of screen
;; 2 | Tile Number | 0 - 256, tile number for the graphic to be taken from the pattern table.
;; 3 | Attributes  | Holds color and display info:
;;                   76543210
;;                   |||   ||
;;                   |||   ++- Color Palette of sprite.  Choose which set of 4 from the 16 colors to use
;;                   |||
;;                   ||+------ Priority (0: in front of background; 1: behind background)
;;                   |+------- Flip sprite horizontally
;;                   +-------- Flip sprite vertically
;; 4 | X Position  | $00 = left, $F9 = right
;;
;; These 4 bytes repeat 64 times (one set per sprite) to fill the 256 bytes of sprite memory. 
;; To edit sprite 0, change bytes $0200-0203, Sprite 1 is $0204-0207, etc.

DrawSpriteTopLeft:
  LDA #$68
  STA $0200        ; set tile.y pos
  LDA #$08
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$20
  STA $0203        ; set tile.x pos

DrawSpriteTopRight:
  LDA #$68
  STA $0204        ; set tile.y pos
  LDA #$08
  STA $0205        ; set tile.id
  LDA #$40         
  STA $0206        ; set tile.attribute(x-mirror)
  LDA #$28
  STA $0207        ; set tile.x pos

DrawSpriteBottomLeft:
  LDA #$70
  STA $0208        ; set tile.y pos
  LDA #$08
  STA $0209        ; set tile.id
  LDA #$80
  STA $020a        ; set tile.attribute(y-mirror)
  LDA #$20
  STA $020b        ; set tile.x pos

DrawSpriteBottomRight:
  LDA #$70
  STA $020c        ; set tile.y pos
  LDA #$08
  STA $020d        ; set tile.id
  LDA #$c0
  STA $020e        ; set tile.attribute(xy-mirror)
  LDA #$28
  STA $020f        ; set tile.x pos

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