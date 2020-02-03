ENUM $0
ptr .dw 0
ENDE

PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
PPUSTAT   = $2002
SPRADDR   = $2003
OAMADDR   = $2003
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007

; palette

LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0

LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero

DrawLine1:
  LDA #$20              ; Set the PPU address to Row #2, column #2, which is address $2042
  STA PPUADDR
  LDA #32*2 + 2
  STA PPUADDR
  
  LDA #<Line1
  STA ptr+0
  LDA #>Line1
  STA ptr+1

  JSR WriteString       ; Write this string to the PPU

DrawLine2:
  LDA #$20              ; Set the PPU address to Row #2, column #2, which is address $2042
  STA PPUADDR
  LDA #32*4 + 2
  STA PPUADDR
  
  LDA #<Line2
  STA ptr+0
  LDA #>Line2
  STA ptr+1

  JSR WriteString       ; Write this string to the PPU

DrawLine3:
  LDA #$20              ; Set the PPU address to Row #2, column #2, which is address $2042
  STA PPUADDR
  LDA #32*5 + 2
  STA PPUADDR
  
  LDA #<Line3
  STA ptr+0
  LDA #>Line3
  STA ptr+1

  JSR WriteString       ; Write this string to the PPU

DrawLine4:
  LDA #$20              ; Set the PPU address to Row #2, column #2, which is address $2042
  STA PPUADDR
  LDA #32*6 + 2
  STA PPUADDR
  
  LDA #<Line4
  STA ptr+0
  LDA #>Line4
  STA ptr+1

  JSR WriteString       ; Write this string to the PPU

SetScrolling:
  LDA #0
  STA PPUSCROLL
  STA PPUSCROLL
  STA PPUADDR
  STA PPUADDR
  LDA #$1E
  STA PPUMASK

Forever:
  JMP Forever     ; jump back to Forever, infinite loop

WriteVram:        ; Write a small number of bytes to VRAM.
  LDY #0          ; X = number of bytes to write

WriteVramLoop:
  LDA (ptr),y    ; Load byte from PTR
  STA PPUDATA    ; Write to the PPU
  INY            ; Next byte
  DEX            ; One less byte remaining
  BNE WriteVramLoop    ; If we still have bytes left, loop.
  RTS          

WriteString:     ; Writes a null-terminated string to VRAM
  LDY #0
writestring_loop:
  LDA (ptr),y    ; Read the byte from ptr
  BEQ writestring_quit ; If it's a zero byte, quit.
  SEC            ; We are placing ASCII $20 at character number $00 in the graphics, so subtract $20.
  SBC #$20       ; Write to the PPU
  STA $2007      ; Next byte
  INY            ; Loop (we used a BNE here to prevent a possible infinite loop if the string is longer than 256 bytes long)
  BNE writestring_loop
writestring_quit:
  RTS

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  ;;This is the PPU clean up section, so rendering the next frame starts properly.

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA $2005
  STA $2005
  
  RTI             ; return from interrupt

;The text to display
Line1:
  .db "Hello 6502",0

Line2:
  .db "AaBbCcDdEeFfGgHhIiJjKk",0

Line3:
  .db "LlMmNnOoPpQqRrSsTtUuVv",0

Line4:
  .db "WwXxYyZz0123456789",0