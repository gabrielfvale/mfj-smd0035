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

function P:matrix( matrix )
  if #matrix ~= 9 then
    return
  end
  local m = matrix
  local x = self.x
  local y = self.y
  self.x = m[1] * x + m[2] * y + m[3] * 1;
  self.y = m[4] * x + m[5] * y + m[6] * 1;
end

function P:draw(color)
  color = color or {1, 1, 1}

  love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.circle("fill", self.x, self.y, 2)
  love.graphics.pop()
end

return P
