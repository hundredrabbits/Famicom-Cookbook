;;;;;;;;;;;;;;;;;;
;;;   TABLES   ;;;
;;;;;;;;;;;;;;;;;;

    .align $100
    
palette:
  .db $0F,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$0F
  .db $0F,$3B,$15,$0F,$0F,$02,$0F,$0F,$0F,$1C,$15,$14,$31,$02,$38,$3C

sprites:
     ;vert tile attr horiz
  .db $60, $07, $00, $60   ;sprite 0
  .db $60, $08, $00, $68   ;sprite 1
  .db $60, $07, $00, $70   ;sprite 2
  .db $60, $08, $00, $78   ;sprite 3

  .db $68, $09, $00, $60   ;sprite 0
  .db $68, $0b, $00, $68   ;sprite 1
  .db $68, $0c, $00, $70   ;sprite 2
  .db $68, $0a, $00, $78   ;sprite 3

  .db $70, $07, $00, $60   ;sprite 0
  .db $70, $0c, $00, $68   ;sprite 1
  .db $70, $0b, $00, $70   ;sprite 2
  .db $70, $08, $00, $78   ;sprite 3

  .db $78, $09, $00, $60   ;sprite 0
  .db $78, $0a, $00, $68   ;sprite 1
  .db $78, $09, $00, $70   ;sprite 2
  .db $78, $0a, $00, $78   ;sprite 3