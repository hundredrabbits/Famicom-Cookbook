	;Pointers to song data tables

P_INSTRUMENT_TABLE = $07F1
P_DUTY_TABLE	= $07F3
P_PLK_ENV_TABLE	= $07F5
P_GATE_TABLE	= $07F7
P_DRUM_SOUNDS_TABLE = $07F9
P_TRACK_TABLE	= $07FB
P_SEQUENCE_TABLE = $07FD

	;Variables that can be modified by sequence commands
	
LD = $07D0
TRACK_TRANSPOSE = $07D5
SEQ_VELOCITY = $07DA
SWEEP_MODE = $07DF
SWEEP_OFFSET = $07E4
SWEEP_STEP = $07E9
	
NIJUU_INIT_RAM_VECTORS
	lda #<INSTRUMENT_TABLE
	sta P_INSTRUMENT_TABLE
	lda #>INSTRUMENT_TABLE
	sta P_INSTRUMENT_TABLE+1
	
	lda #<DUTY_TABLE
	sta P_DUTY_TABLE
	lda #>DUTY_TABLE
	sta P_DUTY_TABLE+1
	
	lda #<PLK_ENV_TABLE
	sta P_PLK_ENV_TABLE
	lda #>PLK_ENV_TABLE
	sta P_PLK_ENV_TABLE+1
	
	lda #<GATE_TABLE
	sta P_GATE_TABLE
	lda #>GATE_TABLE
	sta P_GATE_TABLE+1
	
	lda #<DRUM_SOUNDS_TABLE
	sta P_DRUM_SOUNDS_TABLE
	lda #>DRUM_SOUNDS_TABLE
	sta P_DRUM_SOUNDS_TABLE+1
	
	lda #<TRACK_TABLE
	sta P_TRACK_TABLE
	lda #>TRACK_TABLE
	sta P_TRACK_TABLE+1
	
	lda #<SEQUENCE_TABLE
	sta P_SEQUENCE_TABLE
	lda #>SEQUENCE_TABLE
	sta P_SEQUENCE_TABLE+1
	rts
		