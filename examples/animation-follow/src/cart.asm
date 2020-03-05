include "src/head.asm"
include "src/main.asm"
include "src/tables.asm"

;; Vectors

  .pad $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;; sprite

  .incbin "src/sprite.chr"