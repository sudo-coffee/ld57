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
  surface = class.surface.new()
  if not player then
    player = class.player.new(192, 192, level.floors[1])
    player:startAudio()
  end
  player:reset()
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
  level:update(surface, player)
  local length = math.sqrt(player.velX ^ 2 + player.velY ^ 2)
  local mouseX, mouseY = view.getMousePosition()
  if player.raise > 0 then
    surface:raise(player.raise)
    player.raise = 0
  end
  if player.ascend then
    surface:uncarve(64 / 255)
  elseif player.descend then
    surface:recarve(64 / 255)
  elseif love.mouse.isDown(1) and love.mouse.isDown(2)
      or love.mouse.isDown(3) then
    surface:uncarve(16 / 255)
  elseif love.mouse.isDown(1) then
    surface:uncarve(0.5 / 255)
    surface:carve(mouseX, mouseY, 1.5 / 255)
  elseif love.mouse.isDown(2) then
    surface:uncarve(0.5 / 255)
    surface:decarve(mouseX, mouseY, 1.0 / 255)
  end
  surface:clamp(level.minDepth, level.maxDepth)
  if player.newgame then
    reset()
  end
end
