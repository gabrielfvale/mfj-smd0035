local Class = require("lib.Class")
local S = Class:derive("Scene")

function S:new( sceneMgr )
  self.sceneMgr = sceneMgr
end

function S:load()
end

function S:update( dt )
end

function S:draw()
end

function S:destroy()
end

function S:exit()
end

return S
