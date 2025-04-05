local view = require("utils.view")
local class = require("class")
local level = require("level")
local world = nil
local player = nil


-- / --------- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ --------- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  view.setDimensions(384, 384)
  floors = level.getFloors()
  world = class.world.new(floors)
  player = class.player.new()
  print(world.floors)
end

function love.draw()
  love.graphics.push("all")
  view.origin()
  world.draw()
  love.graphics.pop()
end
