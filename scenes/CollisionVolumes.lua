local Scene = require("lib.Scene")
local CV = Scene:derive("EnclosingVolumes")

local Point = require("lib.Point")
local Vector2 = require("lib.Vector2")
local AABB = require("lib.AABB")
local OBB = require("lib.OBB")
local MECircle = require("lib.MECircle")

function CV:load()
  local screen_width, screen_height = love.graphics.getDimensions()
  pageOrigin = Point(screen_width / 2, screen_height / 2)

  circle1 = MECircle(pageOrigin, 20)
end

function CV:update( dt )
end

function CV:draw()
  love.graphics.print("Volumes de colisão")
  circle1:draw( {0, 1, 0}, false )
end

return CV
