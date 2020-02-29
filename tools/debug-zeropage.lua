print("Added debugger!")

emu.speedmode("normal") -- Set the speed of the emulator

function printaddr(addr)
  res = string.format("%02x", memory.readbyte(addr) * 256):sub(1, -3)
  len = string.len(res)
  if len == 0 then return "00" elseif len <= 1 then return "0"..res else return res end
end

while true do
  for x=0,15 do 
    for y=0,15 do 
      id = x + (y * 16)
      gui.text((x * 15) + 10, (y * 10) + 15, printaddr(id))
    end
  end
  emu.frameadvance() 
end