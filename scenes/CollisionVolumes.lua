local Scene = require("lib.Scene")
local CV = Scene:derive("EnclosingVolumes")

function CV:load()
end

function CV:update( dt )
end

function CV:draw()
  love.graphics.print("Volumes de colisão")
end

return CV
