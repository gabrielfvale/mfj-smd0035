local Scene = require("lib.Scene")
local EV = Scene:derive("EnclosingVolumes")

local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local AABB = require("lib.AABB")
local OBB = require("lib.OBB")
local MECircle = require("lib.MECircle")

function createRandomPoints(x, y)
  local max_points = love.math.random(5, 40)
  local screen_width, screen_height = love.graphics.getDimensions()

  local x = screen_width/2 or x
  local y = screen_height/2 or y

  local rand = love.math.random()

  for i=1, max_points do
    local x = love.math.random(x - screen_width/4 * rand, x + screen_width/4 * rand)
    local y = love.math.random(y - screen_height/4 * rand, y + screen_height/4 * rand)
    point_cloud[i] = Point(x, y)
  end
end

function makeBoundingVolumes()
  aabb = AABB(point_cloud)
  obb = OBB(Vector2(love.math.random(), love.math.random()), point_cloud)
  circle = MECircle(Point(), 0, point_cloud)
end

keypressed(function (key, unicode)
  if key == "space" then
    createRandomPoints()
    makeBoundingVolumes()
  end
end)

function EV:load()
  local screen_width, screen_height = love.graphics.getDimensions()

  point_cloud = {}
  pageOrigin = Point(screen_width / 2, screen_height / 2)

  createRandomPoints()
  makeBoundingVolumes()
end

function EV:update( dt )

end

function EV:draw( ... )
  -- text
  love.graphics.print("'Espaço' para gerar novos pontos")
  love.graphics.print("A orientação da OBB é gerada aleatoriamente", 0, 20)
  love.graphics.print("O círculo envoltório é mínimo e usa o algoritmo de Welzl, em O(N)", 0, 40)

  -- render point cloud
  for _, p in ipairs(point_cloud) do
    p:render()
  end

  -- render Bounding Volumes
  obb:render( 0, 0.5, 0.5 )
  aabb:render( 0.5, 0, 0.5 )
  circle:render( 0.5, 0.5, 0 )
end

return EV
