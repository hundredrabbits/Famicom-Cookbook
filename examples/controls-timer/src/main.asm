
;;

LoadPalettes:                  ; 
  LDA $2002                    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006                    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006                    ; write the low byte of $3F00 address
  LDX #$00
@loop:                         ; 
  LDA palette, x               ; load palette byte
  STA $2007                    ; write to PPU
  INX                          ; set index to next byte
  CPX #$20
  BNE @loop                    ; if x = $20, 32 bytes copied, all done

;; start render

  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;; let's do it

  JSR InitDeck

;;

Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
checkInputLock:                ; 
  LDA input_timer
  CMP #$00
  BEQ LatchController
  DEC input_timer
  RTI

;;

LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
@a:                            ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ @b
  JSR pullDeck
  JSR lockInput
@b:                            ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ @done
  JSR pullDeck
  JSR lockInput
@done:                         ; handling this button is done
  RTI                          ; return from interrupt

;; Deck: Create a deck of 54($36) cards, from zeropage $40

InitDeck:                      ; 
  LDX #$00
@loop:                         ; 
  TXA
  STA $40, x
  INX
  CPX #$36
  BNE @loop
  RTS

;;

pullDeck:                      ; 
  LDX #$00
@loop:                         ; 
  TXA
  TAY
  INY
  LDA $40, y
  STA $40, x
  INX
  CPX #$36
  BNE @loop
  RTS

;;

lockInput:                     ; 
  LDA #$06
  STA input_timer
  RTS