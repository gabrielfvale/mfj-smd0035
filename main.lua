
local Point = require("Point")
local Vector2 = require("Vector2")
local AABB = require("AABB")
local OBB = require("OBB")
local MECircle = require("MECircle")

function createRandomPoints(x, y)
  local max_points = love.math.random(5, 40)
  local screen_width, screen_height = love.graphics.getDimensions()

  x = screen_width/2 or x
  y = screen_height/2 or y

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

function love.load()
  local screen_width, screen_height = love.graphics.getDimensions()
  pageOrigin = Point(screen_width / 2, screen_height / 2)
  point_cloud = {}
  createRandomPoints()
  makeBoundingVolumes()
end

function love.keypressed(key)
  if key == "space" then
    createRandomPoints()
    makeBoundingVolumes()
  end
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)

end

function love.draw()
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
