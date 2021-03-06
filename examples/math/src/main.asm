; No visuals for this one, use the tools/debug-zeropage.lua script
; Press A/B buttons to change the values in memory

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

  ; load some data up

  LDA #$09
  STA $00    ; memory addr A
  LDA #$05
  STA $01    ; memory addr B

  ; opposite value

  LDA #$00
  SBC #$10
  STA $02

  ;

  JSR Update

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
  INC $00 ; memory addr A
  JSR Update
ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  INC $01 ; memory addr B
  JSR Update
ReadBDone:        ; handling this button is done

  RTI        ; return from interrupt

Update:
  JSR Mod
  STA $10

  JSR Div
  STA $11
  RTS

; modulus, returns in register A

Mod:
  LDA $00  ; memory addr A
  SEC
Modulus:  
  SBC $01  ; memory addr B
  BCS Modulus
  ADC $01
  RTS

; division, rounds up, returns in register A

Div:
  LDA $00 ; memory addr A
  LDX #0
  SEC
Divide:   
  INX
  SBC $01 ; memory addr B
  BCS Divide
  TXA
  RTS