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

;;

SetBitPosY:                    ; 
  LDA #$60
  STA $0200
  STA $0204
  STA $0208
  STA $020c
  STA $0210
  STA $0214
  STA $0218
  STA $021c
SetBitTileAttr:                ; 
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e
  STA $0212
  STA $0216
  STA $021a
  STA $021e
SetBitPosX:                    ; 
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
  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;;

  JSR redraw
Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
LatchController:               ; 
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016                    ; tell both the controllers to latch buttons
ReadA:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadADone
  NOP
ReadADone:                     ; handling this button is done
ReadB:                         ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadBDone
  NOP
ReadBDone:                     ; handling this button is done
ReadSel:                       ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadSelDone
  NOP
ReadSelDone:                   ; handling this button is done
ReadStart:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadStartDone
  NOP
ReadStartDone:                 ; handling this button is done
ReadUp:                        ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadUpDone
  INC $00
  JSR redraw
ReadUpDone:                    ; handling this button is done
ReadDown:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadDownDone
  DEC $00
  JSR redraw
ReadDownDone:                  ; handling this button is done
ReadLeft:                      ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadLeftDone
  NOP
ReadLeftDone:                  ; handling this button is done
ReadRight:                     ; 
  LDA $4016
  AND #%00000001               ; only look at BIT 0
  BEQ ReadRightDone
  NOP
ReadRightDone:                 ; handling this button is done
  RTI                          ; return from interrupt

;;

redraw:                        ; 
@clear:                        ; 
  LDA #$20
  STA $0201
  STA $0205
  STA $0209
  STA $020d
  STA $0211
  STA $0215
  STA $0219
  STA $021d
@test0:                        ; 
  LDA $00
  AND #%00000001
  BEQ @test1
  LDA #$21
  STA $021d
@test1:                        ; 
  LDA $00
  AND #%00000010
  BEQ @test2
  LDA #$21
  STA $0219
@test2:                        ; 
  LDA $00
  AND #%00000100
  BEQ @test3
  LDA #$21
  STA $0215
@test3:                        ; 
  LDA $00
  AND #%00001000
  BEQ @test4
  LDA #$21
  STA $0211
@test4:                        ; 
  LDA $00
  AND #%00010000
  BEQ @test5
  LDA #$21
  STA $020d
@test5:                        ; 
  LDA $00
  AND #%00100000
  BEQ @test6
  LDA #$21
  STA $0209
@test6:                        ; 
  LDA $00
  AND #%01000000
  BEQ @test7
  LDA #$21
  STA $0205
@test7:                        ; 
  LDA $00
  AND #%10000000
  BEQ @done
  LDA #$21
  STA $0201
@done:                         ; 
  RTS