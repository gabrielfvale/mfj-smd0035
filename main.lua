local SceneManager = require("lib.SceneManager")

-- global keypressed for multiple callbacks
local KEYPRESSED={}

function love.keypressed(key, unicode)
  for _,fn in ipairs(KEYPRESSED) do
    fn(key, unicode)
  end
end

function keypressed(fn)
  table.insert( KEYPRESSED, fn )
end

keypressed(function (key, unicode)
  if key == "escape" then
    love.event.quit()
  end
end)

function love.load()
  SM = SceneManager("scenes", { "EnclosingVolumes" })
end

function love.update(dt)
  SM:update(dt)
end

function love.draw()
  SM:draw()
end
