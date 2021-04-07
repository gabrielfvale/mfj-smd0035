local Class = require("lib.Class")
local SM = Class:derive("SceneManager")

function SM:new( dir, scenes )
  dir = dir or ""
  self.scenes = {}
  self.sceneNames = scenes
  self.dir = dir
  self.currentSceneName = "None"

  if scenes ~= nil then
    for i=1, #scenes do
      local M = require(dir .. "." .. scenes[i])
      self.scenes[scenes[i]] = M(self)
    end
    self:switch(scenes[1])
  end

end

function SM:add( scene )
  if scene then
    self.scenes[scene_name] = scene
  end
end

function SM:remove( sceneName )
  if sceneName then
    for key, value in ipairs(self.scenes) do
      if key == sceneName then
        self.scenes[key]:destroy()
        self.scenes[key] = nil
      end
    end
  end
end

function SM:switch( nextScene )
  if self.currentScene then
    self.currentScene:exit()
  end

  if nextScene then
    self.currentSceneName = nextScene
    self.currentScene = self.scenes[nextScene]
    self.currentScene:load()
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
  love.graphics.push("all")
  love.graphics.setColor(0, 0.5, 0)
  love.graphics.print("[TAB para alternar] Cena: " .. self.currentSceneName)
  love.graphics.pop()
  if self.currentScene then
    love.graphics.translate(0, 20)
    self.currentScene:draw( ... )
  end
end

function SM:cycle()
  local index = 1
  local nextIndex = 1

  for k, v in ipairs(self.sceneNames) do
    if v == self.currentSceneName then
      index = k
      nextIndex = index + 1
      if nextIndex > #self.sceneNames then
        nextIndex = 1
      end
    end
  end

  self:switch(self.sceneNames[nextIndex])

end

return SM
