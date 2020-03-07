
;; iNES HEADER

  .db  "NES", $1a              ; identification of the iNES header
  .db  PRG_COUNT               ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|MIRRORING           ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;;

include "src/head.asm"
include "src/main.asm"
include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0
  .incbin "src/sprite.chr"