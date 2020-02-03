emu.speedmode("normal") -- Set the speed of the emulator

-- Declare and set variables or functions if needed

while true do

  -- Execute instructions for FCEUX

  emu.frameadvance() -- This essentially tells FCEUX to keep running
  gui.text(50,50,string.format("%x", memory.readbyte(0x0205) * 256));

end