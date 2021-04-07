local Scene = require("lib.Scene")
local CV = Scene:derive("EnclosingVolumes")

local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local Primitive = require("lib.Primitive")
local AABB = require("lib.AABB")
local OBB = require("lib.OBB")
local MECircle = require("lib.MECircle")

function CV:load()
  local screen_width, screen_height = love.graphics.getDimensions()
  pageOrigin = Point(screen_width / 2, screen_height / 2)

  isDragging = false
  currentObject = nil
  hasCollision = false

  local aabbDim = 40

  objects = {
    MECircle(pageOrigin, 40),
    MECircle(Point(pageOrigin.x + 160, pageOrigin.y), 40),
    MECircle(Point(pageOrigin.x + 320, pageOrigin.y), 40),
    AABB({
      Point(pageOrigin.x - aabbDim/2, pageOrigin.y - aabbDim/2),
      Point(pageOrigin.x + aabbDim/2, pageOrigin.y - aabbDim/2),
      Point(pageOrigin.x + aabbDim/2, pageOrigin.y + aabbDim/2),
      Point(pageOrigin.x - aabbDim/2, pageOrigin.y + aabbDim/2)
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
      if object1:collidesWith(object2) then
        objectCollided[i] = true
        objectCollided[j] = true
        hasCollision = true
      end
    end
  end
end

function CV:update( dt )
  print(hasCollision)
  checkCollisions()
end

function CV:draw()
  love.graphics.print("Volumes de colisão")
  for i, o in ipairs(objects) do
    if hasCollision and objectCollided[i] then
      o:draw(objectColors[i], false)
    else
      o:draw(objectColors[i], false, "fill")
    end
  end
end

return CV
