-- sudo apt install lua5.1 lua-socket

local socket = require("socket")
local udp = assert(socket.udp())

udp = socket.udp()
udp:setsockname("*", 49163)
udp:settimeout(0)

emu.speedmode("normal") -- Set the speed of the emulator

local jump = {
    up = false,
    down = false,
    left = false,
    right = false,
    A = true,
    B = false,
    select = false,
    start = false,
}

local fire = {
    up = false,
    down = false,
    left = false,
    right = false,
    A = false,
    B = true,
    select = false,
    start = false,
}

function passiveUpdate()
  data, ip, port = udp:receivefrom()
  if data then
    if data == "jump" then joypad.write(1, jump) end
    if data == "fire" then joypad.write(1, fire) end
    print("Received: ", data, ip, port)
    -- joypad.write(1, jump)
  end
end

local frame = 0

while true do
  if frame % 10 == 0 then
    passiveUpdate()
  end
  
  emu.frameadvance()
  frame = frame + 1
end