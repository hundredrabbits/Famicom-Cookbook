;;;;;;;;;;;;;;;;;;
;;;   TABLES   ;;;
;;;;;;;;;;;;;;;;;;

  .org $E000

palette:
  .db $0F,$2D,$16,$2D, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F
  .db $0F,$10,$17,$07, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F

shuffleA:
  .db $03,$10,$18,$23,$32,$0f,$06,$2a,$1e,$0b,$34,$17,$0c,$19
  .db $07,$11,$35,$21,$31,$12,$2e,$02,$08,$16,$1f,$1a,$25,$00
  .db $33,$0e,$05,$1d,$26,$13,$1b,$0d,$22,$2b,$28,$29,$20,$1c
  .db $09,$24,$14,$04,$27,$2f,$30,$0a,$2c,$2d,$01,$15

shuffleB:
  .db $1e,$0a,$13,$18,$2b,$02,$08,$0d,$06,$20,$33,$30,$34,$03
  .db $12,$10,$1d,$15,$25,$1c,$22,$28,$21,$04,$07,$26,$23,$01
  .db $2a,$17,$0c,$2d,$32,$2c,$29,$09,$0e,$11,$19,$2f,$31,$1a
  .db $1f,$0f,$2e,$16,$24,$1b,$14,$27,$0b,$05,$35,$00

shuffleC:
  .db $19,$34,$1b,$29,$2b,$15,$16,$1c,$11,$1f,$27,$01,$1d,$0f
  .db $30,$06,$14,$0a,$31,$05,$20,$26,$2c,$00,$0c,$1e,$22,$0b
  .db $33,$07,$04,$0d,$2a,$2f,$08,$28,$23,$21,$25,$12,$0e,$2e
  .db $18,$03,$1a,$10,$32,$35,$09,$24,$13,$2d,$02,$17

shuffleD:
  .db $29,$01,$09,$32,$20,$08,$1c,$19,$18,$30,$23,$05,$1b,$1d
  .db $0c,$13,$03,$0a,$1f,$12,$0b,$21,$1e,$04,$25,$35,$0d,$16
  .db $14,$2a,$00,$15,$06,$33,$17,$24,$0e,$34,$2e,$11,$10,$2c
  .db $07,$2d,$22,$1a,$02,$0f,$27,$26,$28,$31,$2b,$2f