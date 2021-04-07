local Class = require("lib.Class")
local Vec2 = Class:derive("Vector2")

function Vec2:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vec2:render(origin, color, mul)

  color = color or {0.5, 0.5, 0.5}
  mul = mul or 1

  local px =  origin.x + self.x * mul
  local py = origin.y - self.y * mul
  local offset = 8
  local angle = math.atan2(self.y, -self.x);

  love.graphics.push("all")
    love.graphics.setColor( color[1], color[2], color[3] )
    love.graphics.line(origin.x, origin.y, px, py)
    love.graphics.translate(px, py)
    love.graphics.rotate(angle-(math.pi/2))
    love.graphics.polygon('fill', -offset*0.5, offset, offset*0.5, offset, 0, -offset/2)
  love.graphics.pop()
end

function Vec2:mag()
  return math.sqrt( self.x ^ 2 + self.y ^ 2)
end

function Vec2:normalize()
  local mag = self:mag()
  self.x = self.x / mag
  self.y = self.y / mag
  return self    
end

function Vec2:mul(value)
  self.x = self.x * value
  self.y = self.y * value
end

function Vec2:dot(v1)
  return self.x * v1.x + self.y * v1.y
end

function Vec2:cross(v1)
  return self.x * v1.y - self.y * v1.x;
end

function Vec2:normal()
  return Vec2(-self.y, self.x)
end

function Vec2.add(v1, v2)
  return Vec2(v1.x + v2.x, v1.y + v2.y)
end

function Vec2.multiply(v1, mult)
  return Vec2(v1.x * mult, v1.y * mult)
end

function Vec2:copy()
  return Vec2(self.x, self.y)
end

return Vec2
