# NES System Architecture

- ROM: Read Only Memory, holds data that cannot be changed. This is where the game code or graphics is stored on the cart.
- RAM: Random Access Memory, holds data that can be read and written. When power is removed, the chip is erased. A battery can be used to keep power and data valid.
- PRG: Program memory, the code for the game
- CHR: Character memory, the data for graphics
- CPU: Central Processing Unit, the main processor chip
- PPU: Picture Processing Unit, the graphics chip
- APU: Audio Processing Unit, the sound chip inside the CPU

## Registers

The 6502 handles data in its registers, each of which holds one byte(8-bits) of data.  There are a total of three general use and two special purpose registers:

- A: The accumulator handles all arithmetic and logic.  The real heart of the system.
- X, Y: General purpose registers with limited abilities.
- SP: This stack pointer is decremented every time a byte is pushed onto the stack, and incremented when a byte is popped off the stack.
- PC is the program counter - it’s how the processor knows at what point in the program it currently is. It’s like the current line number of an executing script. In the JavaScript simulator the code is assembled starting at memory location $0600, so PC always starts there.
- The Processor status shows the processor flags. Each flag is one bit, so all seven flags live in a single byte. The flags are set by the processor to give information about the previous instruction. More on that later. Read more about the registers and flags here.

## 6502 Processor Overview

```
$0000-0800 - Internal RAM, 2KB chip in the NES
$2000-2007 - PPU access ports
$4000-4017 - Audio and controller access ports
$6000-7FFF - Optional WRAM inside the game cart
$8000-FFFF - Game cart ROM
```

## Lexicon

### Directives

Directives are commands you send to the assembler to do things like locating code in memory. They start with `.` and are indented. This sample directive tells the assembler to put the code starting at memory location $8000, which is inside the game ROM area:

```
  .org $8000
```

### Labels

The label is aligned to the far left and has a `:` at the end. The label is just something you use to organize your code and make it easier to read. The assembler translates the label into an address. Sample label:

```
  .org $8000
MyFunction:
```


### Opcodes

The opcode is the instruction that the processor will run, and is indented like the directives. In this sample, JMP is the opcode that tells the processor to jump to the MyFunction label:

```
  .org $8000
MyFunction:
  JMP MyFunction
```

### Operands

The operands are additional information for the opcode. Opcodes have between one and three operands. In this example the #$FF is the operand:

```
  .org $8000
MyFunction:
  LDA #$FF
  JMP MyFunction
```

### Comments

Comments are to help you understand in English what the code is doing. When you write code and come back later, the comments will save you. You do not need a comment on every line, but should have enough to explain what is happening. Comments start with a ; and are completely ignored by the assembler. They can be put anywhere horizontally, but are usually spaced beyond the long lines.

```
  .org $8000
MyFunction:        ; loads FF into accumulator
  LDA #$FF
  JMP MyFunction
```

## Common Opcodes

### Load/Store opcodes

```
LDA #$0A   ; LoaD the value 0A into the accumulator A
           ; the number part of the opcode can be a value or an address
           ; if the value is zero, the zero flag will be set.
LDX $0000  ; LoaD the value at address $0000 into the index register X
           ; if the value is zero, the zero flag will be set.
LDY #$FF   ; LoaD the value $FF into the index register Y
           ; if the value is zero, the zero flag will be set.
STA $2000  ; STore the value from accumulator A into the address $2000
           ; the number part must be an address
STX $4016  ; STore value in X into $4016
           ; the number part must be an address
STY $0101  ; STore Y into $0101
           ; the number part must be an address
TAX        ; Transfer the value from A into X
           ; if the value is zero, the zero flag will be set
TAY        ; Transfer A into Y
           ; if the value is zero, the zero flag will be set
TXA        ; Transfer X into A
           ; if the value is zero, the zero flag will be set
TYA        ; Transfer Y into A
           ; if the value is zero, the zero flag will be set
```

### Math opcodes

```
ADC #$01   ; ADd with Carry
           ; A = A + $01 + carry
           ; if the result is zero, the zero flag will be set
SBC #$80   ; SuBtract with Carry
           ; A = A - $80 - (1 - carry)
           ; if the result is zero, the zero flag will be set
CLC        ; CLear Carry flag in status register
           ; usually this should be done before ADC
SEC        ; SEt Carry flag in status register
           ; usually this should be done before SBC
INC $0100  ; INCrement value at address $0100
           ; if the result is zero, the zero flag will be set
DEC $0001  ; DECrement $0001
           ; if the result is zero, the zero flag will be set
INY        ; INcrement Y register
           ; if the result is zero, the zero flag will be set
INX        ; INcrement X register
           ; if the result is zero, the zero flag will be set
DEY        ; DEcrement Y
           ; if the result is zero, the zero flag will be set
DEX        ; DEcrement X
           ; if the result is zero, the zero flag will be set
ASL A      ; Arithmetic Shift Left
           ; shift all bits one position to the left
           ; this is a multiply by 2
           ; if the result is zero, the zero flag will be set
LSR $6000  ; Logical Shift Right
           ; shift all bits one position to the right
           ; this is a divide by 2
           ; if the result is zero, the zero flag will be set
```

### Comparison opcodes

```
CMP #$01   ; CoMPare A to the value $01
           ; this actually does a subtract, but does not keep the result
           ; instead you check the status register to check for equal, 
           ; less than, or greater than
CPX $0050  ; ComPare X to the value at address $0050
CPY #$FF   ; ComPare Y to the value $FF
```

### Control Flow opcodes

```
JMP $8000  ; JuMP to $8000, continue running code there
BEQ $FF00  ; Branch if EQual, contnue running code there
           ; first you would do a CMP, which clears or sets the zero flag
           ; then the BEQ will check the zero flag
           ; if zero is set (values were equal) the code jumps to $FF00 and runs there
           ; if zero is clear (values not equal) there is no jump, runs next instruction
BNE $FF00  ; Branch if Not Equal - opposite above, jump is made when zero flag is clear
```

## NES Code Structure

### iNES Header

The 16 byte iNES header gives the emulator all the information about the game including mapper, graphics mirroring, and PRG/CHR sizes. You can include all this inside your asm file at the very beginning.

```
  .inesprg 1   ; 1x 16KB bank of PRG code
  .ineschr 1   ; 1x 8KB bank of CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring (ignore for now)
```

### Banking

NESASM arranges everything in 8KB code and 8KB graphics banks. To fill the 16KB PRG space 2 banks are needed. Like most things in computing, the numbering starts at 0. For each bank you have to tell the assembler where in memory it will start.

```
  .bank 0
  .org $C000
;some code here

  .bank 1
  .org $E000
; more code here

  .bank 2
  .org $0000
; graphics here
```

Adding Binary Files Additional data files are frequently used for graphics data or level data. The incbin directive can be used to include that data in your .NES file. This data will not be used yet, but is needed to make the .NES file size match the iNES header.

```
  .bank 2
  .org $0000
  .incbin "mario.chr"   ;includes 8KB graphics file from SMB1
```

### Vectors

There are three times when the NES processor will interrupt your code and jump to a new location. These vectors, held in PRG ROM tell the processor where to go when that happens. Only the first two will be used in this tutorial.

- NMI Vector: this happens once per video frame, when enabled. The PPU tells the processor it is starting the VBlank time and is available for graphics updates.
- RESET Vector: this happens every time the NES starts up, or the reset button is pressed.
IRQ Vector: this is triggered from some mapper chips or audio interrupts and will not be covered.

These three must always appear in your assembly file the right order. The .dw directive is used to define a Data Word (1 word = 2 bytes):

```
  .bank 1
  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                 ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                 ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial
```

### Reset Code

The reset vector was set to the label RESET, so when the processor starts up it will start from RESET: Using the .org directive that code is set to a space in game ROM. A couple modes are set right at the beginning. We are not using IRQs, so they are turned off. The NES 6502 processor does not have a decimal mode, so that is also turned off. This section does NOT include everything needed to run code on the real NES, but will work with the FCEUXD SP emulator. More reset code will be added later.

```
  .bank 0
  .org $C000
RESET:
  SEI        ; disable IRQs
  CLD        ; disable decimal mode
```

### Completing The Program

Your first program will be very exciting, displaying an entire screen of one color! To do this the first PPU settings need to be written. This is done to memory address $2001. The 76543210 is the bit number, from 7 to 0. Those 8 bits form the byte you will write to $2001.

```
PPUMASK ($2001)

76543210
||||||||
|||||||+- Grayscale (0: normal color; 1: AND all palette entries
|||||||   with 0x30, effectively producing a monochrome display;
|||||||   note that colour emphasis STILL works when this is on!)
||||||+-- Disable background clipping in leftmost 8 pixels of screen
|||||+--- Disable sprite clipping in leftmost 8 pixels of screen
||||+---- Enable background rendering
|||+----- Enable sprite rendering
||+------ Intensify reds (and darken other colors)
|+------- Intensify greens (and darken other colors)
+-------- Intensify blues (and darken other colors)
```

So if you want to enable the sprites, you set bit 3 to 1. For this program bits 7, 6, 5 will be used to set the screen color:

```
  LDA %10000000   ;intensify blues
  STA $2001
Forever:
  JMP Forever     ;infinite loop
```

### Controller Ports

The controllers are accessed through memory port addresses $4016 and $4017.  First you have to write the value $01 then the value $00 to port $4016.  This tells the controllers to latch the current button positions.  Then you read from $4016 for first player or $4017 for second player.  The buttons are sent  one at a time, in bit 0.  If bit 0 is 0, the button is not pressed.  If bit 0 is 1, the button is pressed.

Button status for each controller is returned in the following order: A, B, Select, Start, Up, Down, Left, Right.

```
LDA #$01
STA $4016
LDA #$00
STA $4016     ; tell both the controllers to latch buttons

LDA $4016     ; player 1 - A
LDA $4016     ; player 1 - B
LDA $4016     ; player 1 - Select
LDA $4016     ; player 1 - Start
LDA $4016     ; player 1 - Up
LDA $4016     ; player 1 - Down
LDA $4016     ; player 1 - Left
LDA $4016     ; player 1 - Right

LDA $4017     ; player 2 - A
LDA $4017     ; player 2 - B
LDA $4017     ; player 2 - Select
LDA $4017     ; player 2 - Start
LDA $4017     ; player 2 - Up
LDA $4017     ; player 2 - Down
LDA $4017     ; player 2 - Left
LDA $4017     ; player 2 - Right
```

## Extras

- Bit: The smallest unit in computers. It is either a 1 (on) or a 0 (off), like a light switch.
- Byte: 8 bits together form one byte, a number from 0 to 255. Two bytes put together is 16 bits, forming a number from 0 to 65535. Bits in the byte are numbered starting from the right at 0.
- The 6502js simulator screen pixels go  from `$0200` to `$05e0`.
- The NES screen resolution is `256x240`.

## Links

### NES C Tutorials

- [nerdy night](http://nerdy-nights.nes.science/)
- [nesdev wiki](http://wiki.nesdev.com/w/index.php/Nesdev_Wiki)
- [gregkrsak's first_nes](https://github.com/gregkrsak/first_nes)
- [shiru](https://shiru.untergrund.net/articles/programming_nes_games_in_c.htm)
- [fritzvd](http://blog.fritzvd.com/2016/06/13/Getting-started-with-NES-programming/)
- [nesdoug](https://github.com/nesdoug/01_Hello)

### ASM Tutorial

- [6502JS](https://github.com/skilldrick/6502js)
- [NES ASM](https://patater.com/gbaguy/nesasm.htm)
- [Easy6502](http://skilldrick.github.io/easy6502/)
- [6502](http://6502.org/tutorials/)
- [No More Secrets](https://csdb.dk/release/?id=185341)

### Tools

- [8bitworkshop](https://8bitworkshop.com)
- [neslib](https://github.com/clbr/neslib)
- [cc65](https://cc65.github.io/)
- [Fceux Lua Docs](http://www.fceux.com/web/help/fceux.html?LuaScripting.html)


## Notes

- When you use X it adds the value of X to the memory address and uses the 16-bit value at that address to do the write
- whereas when you use Y it adds the value of Y to the address stored in the memory address it's reading from instead.
- 6502 is little-endian, so $0200 is stored as $00 $02 in memory.
- a HEX number consisting of 4 numbers is 16-bit.

## cc65

```
git clone https://github.com/cc65/cc65.git
cd cc65
make
make avail
```

## Fceux

```
sudo apt-get update -y
sudo apt-get install -y fceux
```

## nestopia

```
sudo apt-get install nestopia
```