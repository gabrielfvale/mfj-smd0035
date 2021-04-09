local Primitive = require("lib.Primitive")
local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local O = Primitive:derive("lib.OBB")

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

  self.hw = obb_width
  self.hh = obb_height

  self.coords = {
    p0.x, p0.y,
    p1.x, p1.y,
    p2.x, p2.y,
    p3.x, p3.y,
  }
  self.vertices = {
    p0, p1, p2, p3
  }

  local x_axis = Vector2(1, 0)
  local adot = self.u:dot(x_axis)
  self.angle = math.acos( adot / (x_axis:mag() * self.u:mag()) )
end

function O:rotatePoint( p0 )
  local radius = math.sqrt( self.c.x^2 + self.c.y^2 )
  local currentAngle = math.atan2(p0.y-self.c.y, p0.x-self.c.x)
  print("angle " .. currentAngle)
  local newAngle = currentAngle - self.angle
  local newX = self.c.x + radius*math.cos(newAngle)
  local newY = self.c.y + radius*math.sin(newAngle)

  return newX, newY
end

function O:isInside( p0 )
  -- set OBB center as origin
  local px, py  = p0.x - self.c.x, p0.y - self.c.y
  -- rotate point
  local newX = math.cos(-self.angle) * px - math.sin(-self.angle) * py
  local newY = math.sin(-self.angle) * px + math.cos(-self.angle) * py

  -- translate back
  newX = newX + self.c.x
  newY = newY + self.c.y

  local xTest = (newX > self.c.x - self.hw) and (newX < self.c.x + self.hw)
  local yTest = (newY > self.c.y - self.hh) and (newY < self.c.y + self.hh)

  return xTest and yTest
end

function O:translate( x, y )
  local translateMatrix = {
    1, 0, x,
    0, 1, y,
    0, 0, 1
  }
  self.c:matrix( translateMatrix )
  local tVecs = {}
  local nCoords = {}

  for i=1,#self.vertices do
    local temp = Point(self.vertices[i].x, self.vertices[i].y)
    temp:matrix( translateMatrix )
    tVecs[i] = temp
    table.insert( nCoords, temp.x )
    table.insert( nCoords, temp.y )
  end

  self.vertices = tVecs
  self.coords = nCoords
end

function O:draw( color, showText, fillMode )
  color = color or { 0.5, 0.5, 0.5 }
  fillMode = fillMode or "line"
  if showText == nil then showText = true end

  -- self.u:render(self.c, {0.5, 0, 0}, 100)
  -- self.v:render(self.c, {0, 0.5, 0}, 100)

  if #self.vertices ~= 0 then
    love.graphics.push("all")
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.polygon( fillMode, self.coords )
    if showText then
      -- rotate label
      love.graphics.translate(self.coords[1], self.coords[2])
      love.graphics.rotate(self.angle)
      love.graphics.print("OBB")
    end
    love.graphics.pop()
  end
end

return O
