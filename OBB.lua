local class = require("class")
local Point = require("Point")
local Vector2 = require("Vector2")
local O = class:derive("OBB")

function project( pts, v )
  min, max = math.huge, -math.huge

  for i=1, #pts do
    dotProd = v:dot(pts[i])
    min = math.min( min, dotProd )
    max = math.max( max, dotProd )
  end

  return { min, max }
end

function O:new( u, pts )
  pts = pts or {}

  self.u = u
  self.u:normalize()
  self.v = u:normal()
  self.pts = pts

  self.pu = project(self.pts, self.u)
  self.pv = project(self.pts, self.v)

  -- calculate center
  local uc = (self.pu[1] + self.pu[2]) * 0.5
  local vc = (self.pv[1] + self.pv[2]) * 0.5
  local vec1, vec2 = Vector2.multiply(self.u, uc), Vector2.multiply(self.v, vc)
  self.c = Point.add(vec1, vec2)

  -- calculate corners
  local obb_width = (self.pu[2]  - self.pu[1]) / 2
  local obb_height = (self.pv[2] - self.pv[1]) / 2

  -- clockwise
  local op0 = { Vector2.multiply(self.u, -obb_width), Vector2.multiply(self.v, -obb_height) }
  local op1 = { Vector2.multiply(self.u, obb_width), Vector2.multiply(self.v, -obb_height) }
  local op2 = { Vector2.multiply(self.u, obb_width), Vector2.multiply(self.v, obb_height) }
  local op3 = { Vector2.multiply(self.u, -obb_width), Vector2.multiply(self.v, obb_height) }

  local p0 = Point.add(op0[1], op0[2])
  p0 = Point.add(p0, self.c)

  local p1 = Point.add(op1[1], op1[2])
  p1 = Point.add(p1, self.c)

  local p2 = Point.add(op2[1], op2[2])
  p2 = Point.add(p2, self.c)

  local p3 = Point.add(op3[1], op3[2])
  p3 = Point.add(p3, self.c)

  self.corners = {
    p0.x, p0.y,
    p1.x, p1.y,
    p2.x, p2.y,
    p3.x, p3.y,
  }

  local x_axis = Vector2(1, 0)
  local adot = self.u:dot(x_axis)
  self.angle = math.acos( adot / (x_axis:mag() * self.u:mag()) )
end

function O:render( ... )
  params = {...}
  color = { 0.5, 0.5, 0.5 }
  if #params == 3 then color = params end

  -- self.u:render(self.c, {0.5, 0, 0}, 100)
  -- self.v:render(self.c, {0, 0.5, 0}, 100)

  if #self.corners ~= 0 then
    love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.polygon( "line", self.corners )
    -- rotate label
    love.graphics.translate(self.corners[1], self.corners[2])
    love.graphics.rotate(self.angle)
    love.graphics.print("OBB")
    love.graphics.pop()
  end
end

return O
