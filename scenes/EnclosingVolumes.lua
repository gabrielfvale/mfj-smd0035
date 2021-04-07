local Scene = require("lib.Scene")

local EV = Scene:derive("EnclosingVolumes")

function EV:update( dt )

end

function EV:draw( ... )
  love.graphics.print("Enclosing volumes", 0, 200)
end

return EV
