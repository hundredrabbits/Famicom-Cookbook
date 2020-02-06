; <+doppel> well during vblank you just set the bg and sprite render bits to 0
; 20:37 <+doppel> in the register $2001
; 20:37 < neauoire> Oh!
; 20:37 < neauoire> That's so interesting, I didn't think of that at all.
; 20:38 < neauoire> so on my load background, I could turn off rendering at the start, and when the loadBackground loop is done, I turn it back on and the frame won't interrupt my drawing of the background?
; 20:38 <+doppel> when you're done writing to vram you need to initialize the vram address, then set the scroll registers and the nametable bits in $2000
; 20:39 <+doppel> but do that in vblank after you've finished writing to vram
; 20:40 <+doppel> that ensures the ppu renders the screen at the appropriate position

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

DrawSprite1:
  LDA #$88
  STA $0200        ; set tile.y pos
  LDA #$05
  STA $0201        ; set tile.id
  LDA #$00
  STA $0202        ; set tile.attribute
  LDA #$88
  STA $0203        ; set tile.x pos

  JSR RenderStart

Forever:
  JMP Forever     ;jump back to Forever, infinite loop

NMI:
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

ReadA: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone
  LDA #$01
  STA should_render
  JSR RenderStart
ReadADone:        ; handling this button is done

ReadB: 
  LDA $4016
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone
  LDA #$00
  STA should_render
  JSR RenderStop
ReadBDone:        ; handling this button is done

  RTI        ; return from interrupt

RenderStart:
  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00010000   ; enable sprites
  STA $2001
  RTS

RenderStop:
  LDA #%10000000   ; disable NMI, sprites from Pattern Table 0
  STA $2000
  LDA #%00000000   ; disable sprites
  STA $2001
  RTS