-- sudo apt install lua5.1 lua-socket

local socket = require("socket")
local udp = assert(socket.udp())

udp = socket.udp()
udp:setsockname("*", 49163)
udp:settimeout(1)

while true do
    data, ip, port = udp:receivefrom()
    if data then
      print("Received: ", data, ip, port)
    end
    socket.sleep(0.01)
end

if data == nil then
  print("timeout")
else
  print(data)
end