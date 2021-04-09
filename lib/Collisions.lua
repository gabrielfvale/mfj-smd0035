local Class = require("lib.Class")
local Collisions = Class:derive("Collisions")

local Point = require("lib.Point")
local AABB = require("lib.AABB")
local Circle = require("lib.MECircle")

function Collisions:new()
end

function Collisions.check( a, b )
  assert(type(a) == "table", "parameter a must be of Type Class!")
  assert(type(a) == "table", "parameter b must be of Type Class!")

  -- self intersections
  if a:is(Circle) and b:is(Circle) then
    local aRadius, aCenter = a.r, a.c
    local bRadius, bCenter = b.r, b.c
    dist = Point.dist(aCenter, bCenter)
    return dist - (aRadius + bRadius) < 0
  end

  if a:is(AABB) and b:is(AABB) then
    local min, max = a.min, a.max
    local bmin, bmax = b.min, b.max
    collided = (min.x < bmax.x) and
               (max.x > bmin.x) and
               (min.y < bmax.y) and
               (max.y > bmin.y)
    return collided
  end

  return false
end

return Collisions
