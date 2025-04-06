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
  love.graphics.setDefaultFilter("nearest")
  view.setDimensions(384, 384)
  reset()
end

function love.draw()
  love.graphics.push("all")
  view.origin()
  level:draw(surface)
  player:draw()
  love.graphics.pop()
end

function love.update()
  local vector = {x=0, y=0}
  if love.keyboard.isDown("w", "up") then
    vector.y = vector.y - 1
  end
  if love.keyboard.isDown("a", "left") then
    vector.x = vector.x - 1
  end
  if love.keyboard.isDown("s", "down") then
    vector.y = vector.y + 1
  end
  if love.keyboard.isDown("d", "right") then
    vector.x = vector.x + 1
  end
  player:move(vector.x, vector.y)
  level:update()
  local length = math.sqrt(player.velX ^ 2 + player.velY ^ 2)
  if love.mouse.isDown(1) then
    local x, y = view.getMousePosition()
    surface:uncarve(0.5 / 255)
    surface:carve(x, y, 1 / 255)
  elseif love.mouse.isDown(2) then
    surface:uncarve(8 / 255)
  end
end
