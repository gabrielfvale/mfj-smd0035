local Class = require("lib.Class")
local SM = Class:derive("SceneManager")

function SM:new( dir, scenes )
  dir = dir or ""
  self.scenes = {}
  self.dir = dir

  if scenes ~= nil then
    for i=1, #scenes do
      local M = require(dir .. "." .. scenes[i])
      self.scenes[scenes[i]] = M(self)
    end
    self:switch(scenes[1])
  end

end

function SM:add( scene )
end

function SM:remove( scene )
end

function SM:switch( nextScene )
  if self.currentScene then
    self.currentScene:exit()
  end

  if nextScene then
    self.currentScene = self.scenes[nextScene]
  end
end

function SM:pop( ... )
end

function SM:update( dt )
  if self.currentScene then
    self.currentScene:update(dt)
  end
end

function SM:draw( ... )
  if self.currentScene then
    self.currentScene:draw( ... )
  end
end

return SM
