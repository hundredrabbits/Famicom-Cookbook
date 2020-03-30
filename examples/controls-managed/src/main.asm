
;;

handleJoy:                     ; 
  LDA next@input
  CMP #$00
  BEQ @done
  LDA next@input
  LDX #$00                     ; release
  STX next@input
  CMP BUTTON_UP
  BEQ onUp@input               ; skip on #$00
  CMP BUTTON_DOWN
  BEQ onDown@input
@done:                         ; 
  JMP __MAIN

;;

onUp@input:                    ; 
  INC $40
  JMP __MAIN

;;

onDown@input:                  ; 
  DEC $40
  JMP __MAIN