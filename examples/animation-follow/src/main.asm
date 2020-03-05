
;; palette

LoadPalettes:                  ; 
  LDA $2002                    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006                    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006                    ; write the low byte of $3F00 address
  LDX #$00                     ; start out at 0
LoadPalettesLoop:              ; 
  LDA palette, x               ; load data from address (palette + the value in x)
  STA $2007                    ; write to PPU
  INX                          ; X = X + 1
  CPX #$20                     ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  

;; sprite

CreateSprite:                  ; 
  LDA #$88
  STA $0200                    ; set tile.y pos
  LDA #$05
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA #$88
  STA $0203                    ; set tile.x pos
CreateFollower:                ; 
  LDA #$88
  STA $0204                    ; set tile.y pos
  LDA #$05
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$88
  STA $0207                    ; set tile.x pos

;; enable sprites

  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; jump back to Forever, infinite loop

Forever:                       ; 
  JMP Forever                  

;; nmi

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer

;; update

  JSR updateFollower

;; controls

LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
ReadA:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadADone
  LDA #$06                     ; sprite tile
  STA $0201
ReadADone:                     ; handling this button is done
ReadB:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  LDA #$06                     ; sprite tile
  STA $0201
ReadBDone:                     ; handling this button is done
ReadSel:                       ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone 
  LDA #$06                     ; sprite tile
  STA $0201
ReadSelDone:                   ; handling this button is done
ReadStart:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone 
  LDA #$06                     ; sprite tile
  STA $0201
ReadStartDone:                 ; handling this button is done
ReadUp:                        ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone 
  DEC $0200
  DEC $0200
  LDA #$01                     ; sprite tile
  STA $0201
ReadUpDone:                    ; handling this button is done
ReadDown:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone 
  INC $0200
  INC $0200
  LDA #$02                     ; sprite tile
  STA $0201
ReadDownDone:                  ; handling this button is done
ReadLeft:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadLeftDone 
  DEC $0203
  DEC $0203
  LDA #$03                     ; sprite tile
  STA $0201
ReadLeftDone:                  ; handling this button is done
ReadRight:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadRightDone 
  INC $0203
  INC $0203
  LDA #$04                     ; sprite tile
  STA $0201
ReadRightDone:                 ; handling this button is done
  RTI                          ; return from interrupt

;;

updateFollower:                ; 
  JSR updateFollowerX
  JSR updateFollowerY
  RTS

;; x

updateFollowerX:               ; 
  LDA $0207                    ; follower x
  CMP $0203                    ; sprite x
  BEQ updateFollowerXDone
  BCC updateFollowerXINC
  DEC $0207
  RTS
updateFollowerXINC:            ; 
  INC $0207
updateFollowerXDone:           ; 
  RTS

;; y

updateFollowerY:               ; 
  LDA $0204                    ; follower x
  CMP $0200                    ; sprite x
  BEQ updateFollowerYDone
  BCC updateFollowerYINC
  DEC $0204
  RTS
updateFollowerYINC:            ; 
  INC $0204
updateFollowerYDone:           ; 
  RTS