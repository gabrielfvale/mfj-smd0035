local Class = require("lib.Class")
-- abstract class
local P = Class:derive("Primitive")

function P:isInside( p0 )
end

function P:translate( x, y )
end

function P:collidesWith( B )
  return false
end

return P
