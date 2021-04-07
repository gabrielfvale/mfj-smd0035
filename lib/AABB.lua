local Class = require("lib.Class")
local A = Class:derive("AABB")

local Point = require("lib.Point")

function A:new( pts )
  pts = pts or {}
  if #pts == 0 then
    self:setEmpty()
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
    
    self.vertices = {
      minX, minY,
      maxX, minY,
      maxX, maxY,
      minX, maxY
    }
  end
end

function A:setEmpty()
  self.min = Point()
  self.max = Point()
  self.center = Point()
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
