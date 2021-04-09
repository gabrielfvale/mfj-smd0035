local Scene = require("lib.Scene")
local CV = Scene:derive("EnclosingVolumes")

local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local Primitive = require("lib.Primitive")
local AABB = require("lib.AABB")
local OBB = require("lib.OBB")
local MECircle = require("lib.MECircle")
local Collisions = require("lib.Collisions")

function CV:load()
  local screen_width, screen_height = love.graphics.getDimensions()
  pageOrigin = Point(screen_width / 2, screen_height / 2)

  isDragging = false
  currentObject = nil
  hasCollision = false

  local aabbDim = 100
  local circleRad = 40
  local offset = 40
  objectPoints = {}

  -- randomize object locations
  for i=1,6 do
    table.insert( objectPoints, love.math.random( 20, screen_width - 20) )
    table.insert( objectPoints, love.math.random( 20, screen_height - 20) )
  end

  objects = {
    MECircle(Point(objectPoints[1], objectPoints[2]), circleRad),
    MECircle(Point(objectPoints[3], objectPoints[4]), circleRad),
    AABB({
      Point(objectPoints[5] - aabbDim/2, objectPoints[6] - aabbDim/2),
      Point(objectPoints[5] + aabbDim/2, objectPoints[6] - aabbDim/2),
      Point(objectPoints[5] + aabbDim/2, objectPoints[6] + aabbDim/2),
      Point(objectPoints[5] - aabbDim/2, objectPoints[6] + aabbDim/2)
    }),
    AABB({
      Point(objectPoints[7] - aabbDim/2, objectPoints[8] - aabbDim/2),
      Point(objectPoints[7] + aabbDim/2, objectPoints[8] - aabbDim/2),
      Point(objectPoints[7] + aabbDim/2, objectPoints[8] + aabbDim/2),
      Point(objectPoints[7] - aabbDim/2, objectPoints[8] + aabbDim/2)
    }),
    OBB(Vector2(1, 0.1), {
      Point(objectPoints[9] - aabbDim, objectPoints[10] - aabbDim/2),
      Point(objectPoints[9] + aabbDim, objectPoints[10] - aabbDim/2),
      Point(objectPoints[9] + aabbDim/2, objectPoints[10] + aabbDim/2),
      Point(objectPoints[9] - aabbDim/2, objectPoints[10] + aabbDim/2)
    }),
    OBB(Vector2(1, 1), {
      Point(objectPoints[11] - aabbDim/2, objectPoints[12] - aabbDim/2),
      Point(objectPoints[11] + aabbDim/2, objectPoints[12] - aabbDim/2),
      Point(objectPoints[11] + aabbDim/2, objectPoints[12] + aabbDim/2),
      Point(objectPoints[11] - aabbDim/2, objectPoints[12] + aabbDim/2)
    }),
  }

  objectColors = {}
  objectCollided = {}

  for i, o in ipairs(objects) do
    local r, g, b = math.random(), math.random(), math.random()
    objectColors[i] = { r, g, b }
    objectCollided[i] = false
  end

  objectPick()
  -- Collisions.sat( objects[3], objects[4] )
end

function objectPick()

  function love.mousepressed(x, y, button)
    local mousePos = Point(x, y)
    for i, o in ipairs(objects) do
      if o:isInside(mousePos) then
        currentObject = i
        isDragging = true
        break
      end
    end
  end

  function love.mousereleased(x, y, button)
    isDragging = false
    currentObject = nil
  end

  function love.mousemoved( x, y, dx, dy, istouch )
    if isDragging then
      objects[currentObject]:translate( dx, dy )
    end
  end

end

function checkCollisions()
  hasCollision = false
  for i=1,#objects do
    objectCollided[i] = false
  end
  for i = 1, #objects - 1 do
    local object1 = objects[i]
    for j = i + 1, #objects do
      local object2 = objects[j]
      if Collisions.check( object1, object2 ) then
        objectCollided[i] = true
        objectCollided[j] = true
        hasCollision = true
      end
    end
  end
end

function CV:update( dt )
  checkCollisions()
end

function CV:draw()
  for i, o in ipairs(objects) do
    if hasCollision and objectCollided[i] then
      o:draw(objectColors[i])
    else
      o:draw(objectColors[i], false, "fill")
    end
  end

  love.graphics.print("Volumes de colisão")
  love.graphics.print("Arraste as formas para movê-las", 0, 20)
  if hasCollision then
    love.graphics.print("Colisão!", 0, 40)
  end
end

return CV
