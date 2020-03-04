# The Famicom Cookbook

This is a collection of tools and [example files](https://github.com/hundredrabbits/Famicom-Cookbook/tree/master/examples) to make [Famicom games](https://100r.co/site/6502_assembly.html).

We had a hard time finding examples for the [asm6 assembler](https://github.com/hundredrabbits/Famicom-Cookbook/tree/master/assembler), most examples out there we could find made use of compilers and toolchains which were exclusively available on Windows, so we've put this together from bits and pieces of example projects we migrated from either nesasm3 or cc65, to the simpler asm6 compiler. We use the [Nasu Editor](https://github.com/hundredrabbits/nasu) to create spritesheets and nametables.

If you have never used assembly before, we recommend that you first begin with [Easy6502](http://skilldrick.github.io/easy6502/).

## Fceux Emulator

These project files will be using the Fceux emulator, to install:

```
sudo apt-get update -y
sudo apt-get install -y fceux
```

To inspect the zeropage values, we've created [debug-zeropage.lua](https://github.com/hundredrabbits/Famicom-Cookbook/blob/master/tools/debug-zeropage.lua).

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