local class = require("class")
local A = class:derive("AABB")

local Point = require("Point")

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
    
    self.corners = {
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

function A:render( ... )
  params = {...}
  color = { 0.5, 0.5, 0.5 }
  if #params == 3 then color = params end
  -- self.min:render( {1, 0, 0} )
  -- self.max:render( {0, 1, 0} )

  if #self.corners ~= 0 then
    love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.polygon( "line", self.corners )
    love.graphics.print("AABB", self.min.x, self.min.y)
    love.graphics.pop()
  end
end

return A
