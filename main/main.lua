local view = require("utils.view")
local data = require("data")
local class = require("class")
local level = nil
local player = nil
local surface = nil


-- / ------- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function reset()
  level = data.getLevel(1)
  player = class.player.new(192, 192)
  surface = class.surface.new()
end


-- / --------- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ --------- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  view.setDimensions(384, 384)
  reset()
end

function love.draw()
  love.graphics.push("all")
  view.origin()
  level:draw(surface)
  love.graphics.pop()
  player:draw()
end

function love.update()
  level:update()
  if love.mouse.isDown(1) then
    local x, y = view.getMousePosition()
    surface:uncarve()
    surface:carve(x, y)
  elseif love.mouse.isDown(2) then
    for _=1,8 do
      surface:uncarve()
    end
  end
end
