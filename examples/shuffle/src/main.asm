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

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001

  JSR InitDeck

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  JSR RunTimer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  JSR CollapseDeck
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  ; shuffle
  JSR ShuffleDeckA
  LDA seed
  CMP #$00
  BEQ ReadBDone
  JSR ShuffleDeckB
  CMP #$01
  BEQ ReadBDone
  JSR ShuffleDeckC
  ; CMP #$02
  ; BEQ ReadBDone
  ; BNE ShuffleDeckD
ReadBDone:        ; handling this button is done

  RTI        ; return from interrupt

; Deck
; Create a deck of 54($36) cards, from zeropage $40

InitDeck:
  LDX #$00
InitDeckLoop:
  LDA shuffleA, x
  STA $40, x
  INX
  CPX #$36
  BNE InitDeckLoop
  RTS
  
ShuffleDeckA:
  LDX #$00
ShuffleDeckALoop:
  LDY shuffleA, x ; store the value
  LDA $40, y
  STA $90, x
  INX
  CPX #$36
  BNE ShuffleDeckALoop
  RTS

ShuffleDeckB:
  LDX #$00
ShuffleDeckBLoop:
  LDY shuffleB, x ; store the value
  LDA $40, y
  STA $90, x
  INX
  CPX #$36
  BNE ShuffleDeckBLoop
  RTS

ShuffleDeckC:
  LDX #$00
ShuffleDeckCLoop:
  LDY shuffleC, x ; store the value
  LDA $40, y
  STA $90, x
  INX
  CPX #$36
  BNE ShuffleDeckCLoop
  RTS

ShuffleDeckD:
  LDX #$00
ShuffleDeckDLoop:
  LDY shuffleD, x ; store the value
  LDA $40, y
  STA $90, x
  INX
  CPX #$36
  BNE ShuffleDeckDLoop
  RTS

CollapseDeck:
  LDX #$00 ; x = where I write
CollapseDeckLoop:
  LDA $90, x
  STA $40, x
  INX
  CPX #$36
  BNE CollapseDeckLoop
  RTS

RunTimer:
  INC seed
  LDA seed
  CMP #$04
  BEQ ResetTimer
  RTS

ResetTimer:
  LDA #$00
  STA seed
  RTS