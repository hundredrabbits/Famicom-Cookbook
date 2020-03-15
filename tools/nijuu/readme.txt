Nijuu - Getting Started
--------------------------------

1) Put everything into a folder called "Nijuu"

2) From the "tools" folder, you'll need to copy the "asm6" executable to your system path. You can also copy the "midi2nij" and "drum2nij" executables to your system path if you intend to use them.

3) While in the newly created "Nijuu" folder, copy "template.nij" and "template.sng" from the "template" folder.

4) Rename the .nij and .sng file to whatever you like, say, "newsong.nij" and "newsong.sng".

5) Edit the .nij file with a plain text editor and make sure you change the "SONG_FILE_NAME" to whatever you named your .sng file, in this case "newsong.sng". Save the file.

6) To build a .NSF file:

asm6 test.nij test.nsf

7) To build a NES ROM file:

asm6 -dNES test.nij test.nes

8) The template song is blank so you should hear nothing. As long as it compiles without error you should be good to go.

9) Read the manual and study the .sng file.

10) Make music with Nijuu.

NOTES
-----

1) The address for Nijuu engine is fixed at $8000. At some point I'll make the whole source available for those who'd like to compile it but for now I've made the decision to just release the engine as a binary file (well, as much as possible). I did this as it should make it easier for someone to make, say, a NESASM version without the mamoth job of having to convert the WHOLE source code.

2) You can output just the engine and music data (i.e. not a NES ROM and not a .NSF file): "asm6 -dRAW test.nij test.bin". You can see how to use Nijuu in your own code in the file "source/reset.asm".

FILES
-----
"build" - unix script to build a project to .NES
"buildnsf" - unix script to build a project to .NSF
"manual" - folder containing the current manual (HTML)
"readme.txt" this file
"source" - folder containing source and binary files that make up Nijuu
"template" - folder containing template Nijuu project file and song file
"tools" - folder containing necessary tools (binary and source)


