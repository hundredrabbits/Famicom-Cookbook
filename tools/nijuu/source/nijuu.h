
;---------------------------------------------------------------
;NIJUU V0.6b - Header File
;---------------------------------------------------------------
NIJUU_ENGINE	EQU $8000
NIJUU_NEW_SONG	EQU $8003
NIJUU_PAUSE	EQU $8006
NIJUU_UNPAUSE	EQU $8009

;---------------------------------------------------------------
; Approximate BPM based on note lengths (for information)
;---------------------------------------------------------------

;base 10 = 90 bpm
;base 9 = 100 bpm
;base 8 = 112.5 bpm
;base 7 = 128.5 bpm
;base 6 = 150 bpm
;base 5 = 180 bpm

;---------------------------------------------------------------
; Duty Settings
;---------------------------------------------------------------

DUTY0	EQU %00000000
DUTY1	EQU %01000000
DUTY2	EQU %10000000
DUTY3	EQU %11000000

;---------------------------------------------------------------
; Note Equates
;---------------------------------------------------------------
_START_NOTE	EQU $00

A1	EQU _START_NOTE+$0
As1	EQU _START_NOTE+$1
Bb1	EQU _START_NOTE+$1
B1	EQU _START_NOTE+$2
C2	EQU _START_NOTE+$3
Cs2	EQU _START_NOTE+$4
Db2	EQU _START_NOTE+$4
D2	EQU _START_NOTE+$5
Ds2	EQU _START_NOTE+$6
Eb2	EQU _START_NOTE+$6
E2	EQU _START_NOTE+$7
F2	EQU _START_NOTE+$8
Fs2	EQU _START_NOTE+$9
Gb2	EQU _START_NOTE+$9
G2	EQU _START_NOTE+$A
Gs2	EQU _START_NOTE+$B
Ab2	EQU _START_NOTE+$B
A2	EQU _START_NOTE+$C
As2	EQU _START_NOTE+$D
Bb2	EQU _START_NOTE+$D
B2	EQU _START_NOTE+$E
C3	EQU _START_NOTE+$F
Cs3	EQU _START_NOTE+$10
Db3	EQU _START_NOTE+$10
D3	EQU _START_NOTE+$11
Ds3	EQU _START_NOTE+$12
Eb3	EQU _START_NOTE+$12
E3	EQU _START_NOTE+$13
F3	EQU _START_NOTE+$14
Fs3	EQU _START_NOTE+$15
Gb3	EQU _START_NOTE+$15
G3	EQU _START_NOTE+$16
Gs3	EQU _START_NOTE+$17
Ab3	EQU _START_NOTE+$17
A3	EQU _START_NOTE+$18
As3	EQU _START_NOTE+$19
Bb3	EQU _START_NOTE+$19
B3	EQU _START_NOTE+$1A
C4	EQU _START_NOTE+$1B
Cs4	EQU _START_NOTE+$1C
Db4	EQU _START_NOTE+$1C
D4	EQU _START_NOTE+$1D
Ds4	EQU _START_NOTE+$1E
Eb4	EQU _START_NOTE+$1E
E4	EQU _START_NOTE+$1F
F4	EQU _START_NOTE+$20
Fs4	EQU _START_NOTE+$21
Gb4	EQU _START_NOTE+$21
G4	EQU _START_NOTE+$22
Gs4	EQU _START_NOTE+$23
Ab4	EQU _START_NOTE+$23
A4	EQU _START_NOTE+$24
As4	EQU _START_NOTE+$25
Bb4	EQU _START_NOTE+$25
B4	EQU _START_NOTE+$26
C5	EQU _START_NOTE+$27
Cs5	EQU _START_NOTE+$28
Db5	EQU _START_NOTE+$28
D5	EQU _START_NOTE+$29
Ds5	EQU _START_NOTE+$2A
Eb5	EQU _START_NOTE+$2A
E5	EQU _START_NOTE+$2B
F5	EQU _START_NOTE+$2C
Fs5	EQU _START_NOTE+$2D
Gb5	EQU _START_NOTE+$2D
G5	EQU _START_NOTE+$2E
Gs5	EQU _START_NOTE+$2F
Ab5	EQU _START_NOTE+$2F
A5	EQU _START_NOTE+$30
As5	EQU _START_NOTE+$31
Bb5	EQU _START_NOTE+$31
B5	EQU _START_NOTE+$32
C6	EQU _START_NOTE+$33
Cs6	EQU _START_NOTE+$34
Db6	EQU _START_NOTE+$34
D6	EQU _START_NOTE+$35
Ds6	EQU _START_NOTE+$36
Eb6	EQU _START_NOTE+$36
E6	EQU _START_NOTE+$37
F6	EQU _START_NOTE+$38
Fs6	EQU _START_NOTE+$39
Gb6	EQU _START_NOTE+$39
G6	EQU _START_NOTE+$3A
Gs6	EQU _START_NOTE+$3B
Ab6	EQU _START_NOTE+$3B
A6	EQU _START_NOTE+$3C
As6	EQU _START_NOTE+$3D
Bb6	EQU _START_NOTE+$3D
B6	EQU _START_NOTE+$3E
C7	EQU _START_NOTE+$3F
Cs7	EQU _START_NOTE+$40
Db7	EQU _START_NOTE+$40
D7	EQU _START_NOTE+$41
Ds7	EQU _START_NOTE+$42
Eb7	EQU _START_NOTE+$42
E7	EQU _START_NOTE+$43
F7	EQU _START_NOTE+$44
Fs7	EQU _START_NOTE+$45
Gb7	EQU _START_NOTE+$45
G7	EQU _START_NOTE+$46
Gs7	EQU _START_NOTE+$47
Ab7	EQU _START_NOTE+$47
A7	EQU _START_NOTE+$48
As7	EQU _START_NOTE+$49
Bb7	EQU _START_NOTE+$49
B7	EQU _START_NOTE+$4A
C8	EQU _START_NOTE+$4B
Cs8	EQU _START_NOTE+$4C
Db8	EQU _START_NOTE+$4C
D8	EQU _START_NOTE+$4D
Ds8	EQU _START_NOTE+$4E
Eb8	EQU _START_NOTE+$4E
E8	EQU _START_NOTE+$4F
F8	EQU _START_NOTE+$50
Fs8	EQU _START_NOTE+$51
Gb8	EQU _START_NOTE+$51
G8	EQU _START_NOTE+$52
Gs8	EQU _START_NOTE+$53
Ab8	EQU _START_NOTE+$53
A8	EQU _START_NOTE+$54
As8	EQU _START_NOTE+$55
Bb8	EQU _START_NOTE+$55
B8	EQU _START_NOTE+$56
C9	EQU _START_NOTE+$57
Cs9	EQU _START_NOTE+$58
Db9	EQU _START_NOTE+$58
D9	EQU _START_NOTE+$59
Ds9	EQU _START_NOTE+$5A
Eb9	EQU _START_NOTE+$5A
E9	EQU _START_NOTE+$5B
F9	EQU _START_NOTE+$5C
Fs9	EQU _START_NOTE+$5D
Gb9	EQU _START_NOTE+$5D

HIGHEST_NOTE	EQU Gb9

;---------------------------------------------------------------
;Voice Number Equates
;---------------------------------------------------------------

VOICE_A	EQU $00
VOICE_B	EQU $01
VOICE_C	EQU $02
VOICE_D	EQU $03

;---------------------------------------------------------------
; Macro Tokens
;---------------------------------------------------------------
M_V	EQU $60	;seq *
M_SV	EQU $70	;seq
M_MV	EQU $71	;seq
M_RV	EQU $72	;seq
;M_MI	EQU $73	;seq *
;M_SI	EQU $74	;seq *
M_D	EQU $80	;seq *
M_R	EQU $A0	;seq *
M_I	EQU $C0	;seq *
M_TV	EQU $E0	;track *
M_P	EQU $F0	;seq *
M_TEMPO	EQU $F1	;track
M_SW	EQU $F2	;seq
M_MI	EQU $F3	;seq *
M_SI	EQU $F4	;seq *
M_DT	EQU $F5	;track/seq *
M_ECHO	EQU $F6	;track/seq *
M_GT	EQU $F7	;track/seq *
M_B	EQU $F8	;seq
M_HOLD	EQU $F9	;seq *
M_RL	EQU $FA	;seq *
M_FADE_OUT	EQU $FA	;track
M_LG	EQU $FB	;seq *
M_TR	EQU $FB	;track
M_SR	EQU $FC	;track/seq *
M_ER	EQU $FD	;track/seq *
M_LP	EQU $FE	;track *
M_ST	EQU $FF	;track *
M_ES	EQU $FF	;seq *

;---------------------------------------------------------------
; DPCM
;---------------------------------------------------------------

	MACRO DPCM_DEF address
	DB <(address >> 6)
	ENDM
	
;---------------------------------------------------------------
;Track Macros
;---------------------------------------------------------------

	;
	;TEMPO
	; @0 = tempo
	MACRO TEMPO @0
	db M_TEMPO,@0
	ENDM
	
	;
	;FADE_OUT
	; Fade out master volume
	; @0 = speed, higher = slower
	; @1 = volume below which Voice C is stopped
	;
	MACRO FADE_OUT @0,@1
	DB M_FADE_OUT,@0,@1
	ENDM
	
	;
	;TV - set track volume
	; @0 = volume, $00 to $0F
	;
	MACRO TV @0
	DB M_TV+@0
	ENDM
	
	;
	;GT turn gate effect on
	; <pattern>,<speed>,<off amp>,<sync mode>
GATE_END	EQU $FF
	MACRO GT @0,@1,@2,@3
SYNC_ON	= $80
SYNC_OFF	= $00
	DB M_GT,@0,@1,@2+@3
	ENDM
	
	;
	;GT_OFF turn gate effect off
	;
	MACRO GT_OFF
	DB M_GT,$00,$00,$00
	ENDM
	

	;
	;TR - set track transpose
	; @0 = transpose value $00-$FF (-128 to +127)
	;
	MACRO TR @0
	DB M_TR,@0
	ENDM

	;
	;SR - set track repeat start
	; @0 = number of times to repeat section until repeat end
	;
	MACRO SR @0
	DB M_SR,@0
	ENDM
	
	;
	;ER - set track repeat end
	; no parameters
	MACRO ER
	DB M_ER
	ENDM
	
	;
	;LP- cause track to loop back to specified track address
	; @0 = 16-bit address
	;
	MACRO LP @0
	DB M_LP,<@0,>@0
	ENDM
	
	;
	;ST - cause track to stop
	; no parameters
	;
	MACRO ST
	DB M_ST
	ENDM
	
;---------------------------------------------------------------
; Sequence Macros
;---------------------------------------------------------------

	;
	;SV - set variable
	; <var address>,<value>
	MACRO SV @0,@1
	DB M_SV,<@0,>@0,@1
	ENDM

	;
	;MV - modify variable
	; <var address>,<value>
	MACRO MV @0,@1
	DB M_MV,<@0,>@0,@1
	ENDM
	
	;
	;RV - assign random number to variable
	; <var address>,<lower limit>,<upper limit>
	MACRO RV @0,@1,@2
	DB M_RV,<@0,>@0,@1,(@2-@1)+1
	ENDM

	;
	;SW - pitch sweep
	; <mode>,<offset>,<step>
	MACRO SW @0,@1,@2
OFF	= 0
UP_NOTE	= %00000001
DN_NOTE	= %10000001
UP_FREQ	= %00000010
DN_FREQ	= %10000010
	db M_SW,@0,@1,@2
	ENDM
	
	MACRO SW_OFF
	DB M_SW,0,0,0
	ENDM
	

	;
	;HOLD - stop drum track from stealing channel
	; @0 = amplitude below which to auto steal
	MACRO HOLD @0
OFF	= 0
	db M_HOLD,@0
	ENDM
	
	;
	;V - set velocity of notes
	; @0 = velocity (volume) $00-$0F
	;
	MACRO V @0
	DB M_V+@0
	ENDM
	
	;
	;D - set duration of notes
	; @0 = duration $00-$FF
	; if duration > $1F, extra byte used
	;
	MACRO D @0
	if @0<=$1F
	db M_D+@0
	else
	db M_D,@0
	endif
	ENDM
	
	;
	;R - insert a rest
	; no parameters
	;
	MACRO R
	DB M_R
	ENDM

	;Secondary definition of rest for putting in db lines
_	EQU M_R

	;
	;RD - insert a rest with a duration
	; @0 = duration of rest
	; if duration > $1E, extra byte used
	;
	MACRO RD @0
	if @0<=$1E
	DB M_R+@0
	else
	DB M_R+$1F,@0
	endif
	ENDM
	
	;
	;I - select instrument for track
	; @0 = instrument number
	; if instrument > $1F, extra byte used
	;
	MACRO I @0
	if @0=$00
	db M_I,$00
	elseif @0<=$1F
	DB M_I+@0
	else
	DB M_I,@0
	endif
	ENDM
	
	;
	;P - set portamento
	; <speed>,<delay>
	;
	MACRO P @0,@1
	DB M_P,@0,@1
	ENDM
	
	MACRO P_OFF
	DB M_P,0,0
	ENDM

	;
	;PLG - set portamento & LG
	; <speed>,<delay>
	;
	MACRO PLG @0,@1
	DB M_P,$80+@0,@1
	ENDM
	
	MACRO PLG_OFF
	db M_P,0,0
	ENDM
	
	;
	;B - play pitch bend
	; @0=start note, @1=end note, @2=speed, @3=delay
	MACRO B @0,@1,@2,@3
	DB M_B,@0,@2,@3,@1
	ENDM
	
	;
	;MI - modify instrument parameter
	; @0 - parameter to modify
	; @1 - value added to current value of @0
	;
	MACRO MI @0,@1
	if @0=PLK_MODE
OFF	= %11111111
REL	= %00000000
ABS	= %00000001
REL_DCM	= %00000010
ABS_DCM	= %00000011
NOISE	= %00000100
SQ	= %00000101
TRI	= %00000110
HIGH	= $01
LOW	= $00
	elseif @0=ARP_MODE
OFF	= $FF
REL	= $01
ABS	= $02
	elseif @0=DCM_MODE
OFF	= $FF
CNTR_LOOP	= %00000000
CNTR_HOLD	= %00000010
NOTE_LOOP	= %00000001
NOTE_HOLD	= %00000011
	elseif @0=VIB_DEPTH_ADD
OFF	= 0
	endif
	db M_MI,@1,@0		;swap parameters around to simplify code
	ENDM
	
	;
	;SI - set instrument parameter
	; @0 - parameter to set
	; @0 - parameter value
	;
	MACRO SI @0,@1
NOISE	= %00000100
SQ	= %00000101
TRI	= %00000110
HIGH	= $01
LOW	= $00
	if @0=PLK_MODE
OFF	= %11111111
REL	= %00000000
ABS	= %00000001
REL_DCM	= %00000010
ABS_DCM	= %00000011
	elseif @0=ARP_MODE
OFF	= $FF
REL	= $01
ABS	= $02
	elseif @0=DCM_MODE
OFF	= $FF
CNTR_LOOP	= %00000000
CNTR_HOLD	= %00000010
NOTE_LOOP	= %00000001
NOTE_HOLD	= %00000011
	elseif @0=VIB_DEPTH_ADD
OFF	= 0
	endif
	if @0=ARP_COUNT
	DB M_SI,#ARP_INDEX_0+@1,@0	;end index
	else
	DB M_SI,#@1,@0		;swap parameters around to simplify code
	endif
	ENDM
	
	;
	;DT - set detune (fine offset) for sequence
	; @0 = detune amount
	;
	MACRO DT @0
	DB M_DT,@0
	ENDM
	
	;
	;ECHO - set single tap delay settings for sequence/track
	; @0 = speed
	; @1 = initial amplitude attenuation
	; @2 = amount echo amplitude attenuated every cycle (speed)
	; @3 = number of buffer cycles between attenuation (0=normal)
	; @4 = force duty of echo
	MACRO ECHO @0,@1,@2,@3,@4
OFF	= $FF
	DB M_ECHO,@0,@1,@2,@3,@4
	ENDM
		
	;
	;ECHO_OFF - turn echo off
	;
	MACRO ECHO_OFF
	db M_ECHO,$00,$00,$00,$00,$00
	ENDM
	
	
	;
	;RL - note off (release) command
	;
	MACRO RL
OFF	= 0
	DB M_RL
	ENDM
	
	;
	;LG - set legato mode
	; no parmeters
	;
LG_TRAN1	EQU %00000001
LG_TRAN2	EQU %10000001
LG_HOLD1	EQU %00000010
LG_HOLD2	EQU %10000011
 
	MACRO LG @0
OFF	= 0
TRAN1	= LG_TRAN1
TRAN2	= LG_TRAN2
HOLD1	= LG_HOLD1
HOLD2	= LG_HOLD2
	DB M_LG,@0
	ENDM
		
	;
	;ES - set end of sequence
	; no parameters
	;
	MACRO ES
	DB M_ES
	ENDM
	
	;SR (start repeat) and ER (end repeat) use same token as equivalent track command
	
;---------------------------------------------------------------
;Instrument Parameter Equates
;---------------------------------------------------------------

ENV_ATTACK	EQU 0
ENV_DECAY	EQU ENV_ATTACK+1
ENV_SUSTAIN	EQU ENV_DECAY+1
ENV_RELEASE	EQU ENV_SUSTAIN+1
ENV_DEC_AMP	EQU ENV_RELEASE+1
ENV_SUS_AMP	EQU ENV_DEC_AMP+1

DCM_MODE	EQU ENV_SUS_AMP+1
DCM_START	EQU DCM_MODE+1
DCM_END	EQU DCM_START+1
DCM_SPEED	EQU DCM_END+1

PLK_MODE	EQU DCM_SPEED+1
PLK_PITCH	EQU PLK_MODE+1
PLK_AMP	EQU PLK_PITCH+1
PLK_TIME	EQU PLK_AMP+1
PLK_AUX	EQU PLK_TIME+1

PLK_VOICE	= PLK_PITCH
PLK_PATTERN	= PLK_AMP
PLK_FRAMES	= PLK_TIME
PLK_PRIORITY	= PLK_AUX

ARP_MODE	EQU PLK_AUX+1
ARP_SPEED	EQU ARP_MODE+1
ARP_COUNT	EQU ARP_SPEED+1
ARP_INDEX_0	EQU ARP_COUNT+1
ARP_INDEX_1	EQU ARP_INDEX_0+1
ARP_INDEX_2	EQU ARP_INDEX_1+1
ARP_INDEX_3	EQU ARP_INDEX_2+1
ARP_INDEX_4	EQU ARP_INDEX_3+1

VIB_DEPTH	EQU ARP_INDEX_4+1
VIB_SPEED	EQU VIB_DEPTH+1
VIB_DELAY	EQU VIB_SPEED+1
VIB_DEPTH_ADD	EQU VIB_DELAY+1

INSTRUMENT_SIZE	EQU VIB_DEPTH_ADD+1

DRUM_FRAME_END	EQU $FE
DRUM_END	EQU $FF

;---------------------------------------------------------------
; Instrument Definition Macros	
;---------------------------------------------------------------

	;
	;ENV - define software amplitude envelope
	; <attack>,<decay>,<sustain>,<release>,<dec amp>,<sus amp>
	;
	MACRO ENV @0,@1,@2,@3,@4,@5
	DB @0,@1,@2,@3,@4,@5
	ENDM
		
	;
	;DCM - define duty cycle modulation
	; <mode>,<start>,<end>,<speed>
	;
	MACRO DCM @0,@1,@2,@3
OFF	= $FF
CNTR_LOOP	= %00000000
CNTR_HOLD	= %00000010
NOTE_LOOP	= %00000001
NOTE_HOLD	= %00000011
	db @0,@1,@2+1,@3
	ENDM
	
	;
	;PLK - define pluck sound
	; <mode>,<pitch>,<amp offset>,<time>,<aux> (aux used for DCM pluck)
	;
PLK_NOISE	EQU %00000100
PLK_SQ	EQU %00000101
PLK_TRI	EQU %00000110
	MACRO PLK @0,@1,@2,@3,@4
OFF	= %11111111
REL	= %00000000
ABS	= %00000001
REL_DCM	= %00000010
ABS_DCM	= %00000011
NOISE	= %00000100
SQ	= %00000101
TRI	= %00000110
HIGH	= $01
LOW	= $00
	DB @0,@1,@2,@3,@4
	ENDM
	
	;
	;ARP - define arpeggio 
	; <mode>,<speed>,<count>,<0>,<1>,<2>,<3>,<4>
	;
	MACRO ARP @0,@1,@2,@3,@4,@5,@6,@7
OFF	= $FF
REL	= $01
ABS	= $02
	DB @0,@1
	DB #ARP_INDEX_0+@2	;end index
	DB @3,@4,@5,@6,@7
	ENDM
	
	;
	;VIB - define vibrato
	; <depth>,<speed>,<delay>,<depth add>
	;
	MACRO VIB @0,@1,@2,@3
	DB @0,@1,@2,@3
	ENDM
		
;---------------------------------------------------------------
; Drum Macros
;---------------------------------------------------------------

	;
	;Define drum frame for A
	;  @0=note
	;  @1=amplitude (0-15)
	;  @2=duty
	;
	MACRO DRUM_A @0,@1,@2
	DB VOICE_A,@0,@1,@2
	ENDM
	
	;
	;Define drum frame for B
	;  @0=note
	;  @1=amplitude (0-15)
	;  @2=duty
	;
	MACRO DRUM_B @0,@1,@2
	DB VOICE_B,@0,@1,@2
	ENDM
	
	;
	;Define drum frame for C
	;  @0=note
	;
	MACRO DRUM_C @0
	DB VOICE_C,@0 ;,0,0
	ENDM
	
	;
	;Define drum frame for D
	;  @0=note
	;  @1=amplitude (0-15)
	;
	MACRO DRUM_D @0,@1
	DB VOICE_D,@0,@1 ;,0
	ENDM
	
	;
	;Define end of drum frame
	;
	MACRO DFE
	DB DRUM_FRAME_END
	ENDM
	
	;
	;Define end of drum
	;
	MACRO DE
	DB DRUM_END
	ENDM
;---------------------------------------------------------------
;End of Header File
;---------------------------------------------------------------

	;.include "nijuu_vars.h"
