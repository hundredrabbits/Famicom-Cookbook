;;;;;;;;;;;;;;;;;;
;;;   TABLES   ;;;
;;;;;;;;;;;;;;;;;;

  .org $E000
  
palette:
  .db $3B,$30,$56,$0F,  $22,$36,$17,$0F,  $22,$53,$21,$0F,  $22,$27,$34,$0F   ;;background palette
  .db $0f,$37,$3B,$0F,  $22,$3B,$17,$0F,  $3B,$3B,$3B,$0F,  $22,$27,$34,$0F   ;;sprite palette

sprites:
  ;   vert tile attr horiz
  .db $80, $32, $00, $80   ;sprite 0
  .db $80, $33, $00, $88   ;sprite 1
  .db $88, $34, $00, $80   ;sprite 2
  .db $88, $35, $00, $88   ;sprite 3