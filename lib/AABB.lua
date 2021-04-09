local Primitive = require("lib.Primitive")
local A = Primitive:derive("AABB")

local Point = require("lib.Point")

function A:new( pts )
  pts = pts or {}
  if #pts == 0 then
    self.min = Point()
    self.max = Point()
  else
    minX, minY = math.huge, math.huge
    maxX, maxY = -math.huge, -math.huge

    for _, p in ipairs( pts ) do
      minX = math.min( minX,p.x )
      minY = math.min( minY,p.y )

      maxX = math.max( maxX,p.x )
      maxY = math.max( maxY,p.y )
    end

    self.min = Point(minX, minY)
    self.max = Point(maxX, maxY)
    local w, h = (maxX - minX), (maxY - minY)
    self.c = Point(minX + w/2, minY + h/2)
    self:calcVertices()

  end
end

function A:calcVertices()
  local min, max = self.min, self.max
  self.vertices = {
    min.x, min.y,
    max.x, min.y,
    max.x, max.y,
    min.x, max.y
  }
end

function A:isInside( p0 )
  local min, max = self.min, self.max
  local xTest = (p0.x >= min.x and p0.x <= max.x)
  local yTest = (p0.y >= min.y and p0.y <= max.y)
  return xTest and yTest
end

function A:translate( x, y )
  local translateMatrix = {
    1, 0, x,
    0, 1, y,
    0, 0, 1
  }
  self.min:matrix( translateMatrix )
  self.max:matrix( translateMatrix )
  self.c:matrix( translateMatrix )
  self:calcVertices()
end

function A:draw( color, showText, fillMode )
  color = color or { 0.5, 0.5, 0.5 }
  fillMode = fillMode or "line"
  if showText == nil then showText = true end
  -- self.min:render( {1, 0, 0} )
  -- self.max:render( {0, 1, 0} )

  if #self.vertices ~= 0 then
    love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.polygon( fillMode, self.vertices )
    if showText then
      love.graphics.print("AABB", self.min.x, self.min.y)
    end
    love.graphics.pop()
  end
end

return A
