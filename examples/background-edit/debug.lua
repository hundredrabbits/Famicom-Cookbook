emu.speedmode("normal") -- Set the speed of the emulator

-- Declare and set variables or functions if needed

while true do

  -- Execute instructions for FCEUX

  emu.frameadvance() -- This essentially tells FCEUX to keep running
  gui.text(20,20,string.format("x:%x y:%x", memory.readbyte(0x0000) * 256, memory.readbyte(0x0001) * 256));
end