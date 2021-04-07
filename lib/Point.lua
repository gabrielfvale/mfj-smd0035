local Class = require("lib.Class")
local P = Class:derive("Point")

function P:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function P.add(p0, p1)
  return P(p0.x + p1.x, p0.y + p1.y)
end

function P.dist(p0, p1)
  return math.sqrt( (p0.x - p1.x) ^ 2 + (p0.y - p1.y) ^ 2 )
end

function P:render(color)
  color = color or {1, 1, 1}

  love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.circle("fill", self.x, self.y, 2)
  love.graphics.pop()
end

return P
