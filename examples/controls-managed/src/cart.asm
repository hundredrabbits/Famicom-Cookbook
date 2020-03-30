
;; Cart

  include "src/head.asm"

;;

  .org $C000

;; init

__INIT:                        ; 
  include "src/init.asm"

;; jump back to Forever, infinite loop

__MAIN:                        ; 
  include "src/main.asm"
  JMP __MAIN

;; NMI

__NMI:                         ; 
  include "src/nmi.asm"        ; 
  RTI                          ; return from interrupt

;;

  include "src/tables.asm"

;; vectors

  .pad $FFFA
  .dw __NMI
  .dw __INIT
  .dw 0

;; include sprites

  .incbin "src/sprite.chr"