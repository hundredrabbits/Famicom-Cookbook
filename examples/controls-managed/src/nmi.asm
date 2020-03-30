
;; nmi

readJoy:                       ; 
  LDA #$01
  STA JOY1                     ; start reading
  STA down@input
  LSR a
  STA JOY1
@loop:                         ; 
  LDA JOY1
  LSR a
  ROL down@input
  BCC @loop

;;

saveJoy:                       ; 
  LDA down@input
  CMP last@input
  BEQ @done
  STA last@input
  CMP #$00
  BEQ @done
  STA next@input
@done:                         ; 