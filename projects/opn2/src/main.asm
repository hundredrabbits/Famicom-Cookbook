  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes

;;

EnableSprites:                 ; 
  LDA #%10010000               ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110               ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00                     ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005

;;

Forever:                       ; 
  JMP Forever                  ; jump back to Forever, infinite loop

;;

LoadBackground:                ; 
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  LDA #<background             ; Loading the #LOW(var) byte in asm6
  STA bg_lb
  LDA #>background             ; Loading the #HIGH(var) byte in asm6
  STA bg_hb
  LDX #$00
  LDY #$00
@loop:                         ; 
  LDA (bg_lb), y
  STA $2007
  INY
  CPY #$00
  BNE @loop
  INC bg_hb
  INX
  CPX #$04
  BNE @loop
  RTS

;;

LoadPalettes:                  ; 
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
@loop:                         ; 
  LDA palettes, x
  STA $2007
  INX
  CPX #$20
  BNE @loop
  RTS

;;

LoadAttributes:                ; 
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
@loop:                         ; 
  LDA attributes, x
  STA $2007
  INX
  CPX #$40
  BNE @loop
  RTS

;;

NMI:                           ; 
  LDA #$00
  STA $2003                    ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014                    ; set the high byte (02) of the RAM address, start the transfer
  RTI                          ; return from interrupt