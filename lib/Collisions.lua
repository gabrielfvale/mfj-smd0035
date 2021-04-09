local Class = require("lib.Class")
local Collisions = Class:derive("Collisions")

local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local AABB = require("lib.AABB")
local OBB = require("lib.OBB")
local Circle = require("lib.MECircle")

function Collisions:new()
end

function Collisions:circle_circle( a, b )
  local aRadius, aCenter = a.r, a.c
  local bRadius, bCenter = b.r, b.c
  dist = Point.dist(aCenter, bCenter)
  return dist - (aRadius + bRadius) < 0
end

function Collisions:aabb_aabb( a, b )
  local min, max = a.min, a.max
  local bmin, bmax = b.min, b.max
  collided = (min.x < bmax.x) and
             (max.x > bmin.x) and
             (min.y < bmax.y) and
             (max.y > bmin.y)
  return collided
end

function Collisions:circle_aabb( c, a )
  local cCenter, aCenter = c.c, a.c
  local radius = c.r
  local min, max = a.min, a.max
  local w, h = (max.x - min.x), (max.y - min.y)

  dist = Point(math.abs(cCenter.x - aCenter.x), math.abs(cCenter.y - aCenter.y))

  if dist.x > (w/2 + radius) then return false end
  if dist.y > (h/2 + radius) then return false end

  if dist.x <= (w/2) then return true end
  if dist.y <= (h/2) then return true end

  cornerDistance_sq = (dist.x - w/2)^2 +
                      (dist.y - h/2)^2;

  return (cornerDistance_sq <= (radius^2));
end

function Collisions:circle_obb( c, o )
  local circleCenter, obbCenter = c.c, o.c
  local radius = c.r
  local vertices = o.vertices
  local max = -math.huge

  local dist = Vector2(circleCenter.x - obbCenter.x, circleCenter.y - obbCenter.y)
  local distNorm = dist:copy()
  distNorm:normalize()

  for i = 1, #vertices, 2 do
    local currentVertice = Point(vertices[i], vertices[i+1])
    local v = Vector2(currentVertice.x - obbCenter.x, currentVertice.y - obbCenter.y)
    local proj = v:dot(distNorm)

    if max < proj then max = proj end
  end

  if (dist:mag() - max - radius > 0) and dist:mag() > 0 then
    return false
  else
    return true
  end
end

function Collisions.check( a, b )
  assert(type(a) == "table", "parameter a must be of Type Class!")
  assert(type(a) == "table", "parameter b must be of Type Class!")

  -- self intersections
  if a:is(Circle) and b:is(Circle) then
    return Collisions:circle_circle( a, b )
  end

  if a:is(AABB) and b:is(AABB) then
    return Collisions:aabb_aabb( a, b )
  end

  -- circle x aabb
  if a:is(Circle) and b:is(AABB)  then
    return Collisions:circle_aabb( a, b )
  elseif a:is(AABB) and b:is(Circle)  then
    return Collisions:circle_aabb( b, a )
  end

  -- circle x obb
  if a:is(Circle) and b:is(OBB)  then
    return Collisions:circle_obb( a, b )
  elseif a:is(OBB) and b:is(Circle)  then
    return Collisions:circle_obb( b, a )
  end
  return false
end

return Collisions
