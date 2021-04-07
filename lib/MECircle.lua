local Primitive = require("lib.Primitive")
local C = Primitive:derive("MECircle")

local Point = require("lib.Point")

function C:new( c, r, pts )
  pts = pts or {}
  self.c = c
  self.r = r
  if #pts > 1 then
    local minCircle = self:welzl( pts )
    self.c = minCircle.c
    self.r = minCircle.r
  end
end

function C:isInside( p0 )
  local c = self.c
  local dist = Point.dist( c, p0 )
  return dist <= self.r
end

function C:translate( x, y )
  local translateMatrix = {
    1, 0, x,
    0, 1, y,
    0, 0, 1
  }
  self.c:matrix( translateMatrix )
end

function C:collidesWith( B )
  if B:is(C) then -- circle x circle
    local radius = B.r
    local center = B.c
    dist = Point.dist(self.c, center)
    return dist - (self.r + radius) < 0
  end
  return false
end

function C:getCenter( b, c )
  local B = b.x^2 + b.y^2
  local C = c.x^2 + c.y^2
  local D = b.x * c.y - b.y * c.x

  local cx = (c.y * B - b.y * C) / (2 * D)
  local cy = (b.x * C - c.x * B) / (2 * D)
  return Point(cx, cy)
end

function C:fromThree( a, b, c )
  local i = self:getCenter(Point(b.x - a.x, b.y - a.y), Point(c.x - a.x, c.y - a.y))
  i.x = i.x + a.x
  i.y = i.y + a.y
  return C(i, Point.dist(i, a))
end

function C:fromTwo( a, b )
  local c = Point( (a.x + b.x) / 2, (a.y + b.y) / 2 )
  return C(c, Point.dist(a, b) / 2)
end

function C:isValid( circle, pts )
  for _, p in ipairs( pts ) do
    if not circle:isInside( p ) then
      return false
    end
  end
  return true
end

function C:minCircleTrivial( pts )
  assert(#pts <= 3, "Error")
  if #pts == 0 then
    return C(Point(), 0)
  elseif #pts == 1 then
    return C(pts[1], 0)
  elseif #pts == 2 then
    return self:fromTwo(pts[1], pts[2])
  end

  return self:fromThree(pts[1], pts[2], pts[3])

end

function C:welzlRecursion( P, R, n )
  -- P is the vector of points
  -- R determines the circle

  local P = { unpack(P) }
  local R = { unpack(R) }

  -- base case when #P = 0 or #R = 3
  if n == 0 or #R == 3 then
    return self:minCircleTrivial( R )
  end

  local index = math.random( 1, n )
  local randomPoint = P[index]
  P[index] = P[n]
  P[n] = randomPoint

  local dCircle = self:welzlRecursion(P, R, n - 1)

  if dCircle:isInside( randomPoint ) then
    return dCircle
  end

  table.insert( R, randomPoint )

  return self:welzlRecursion(P, R, n - 1)

end

function C:welzl( pts )
  local P = { unpack(pts) }
  return self:welzlRecursion( P, {}, #P )
end

function C:draw( color, showText, fillMode )
  color = color or { 0.5, 0.5, 0.5 }
  fillMode = fillMode or "line"
  if showText == nil then showText = true end

  love.graphics.push("all")
    love.graphics.setColor(color)
    love.graphics.circle(fillMode, self.c.x, self.c.y, self.r)
    if showText then
      love.graphics.print("Welzl's MEC", self.c.x - 35, self.c.y - self.r - 15)
    end
  love.graphics.pop()

end

return C
