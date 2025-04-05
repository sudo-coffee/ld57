local class = require("class")
local data = {}
data.floor = {}
data.level = {}


-- / ------ \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Floors | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------ / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Blank --

data.floor.blank = {}

function data.floor.blank.new(depth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/blank.png")
  setmetatable(self, {__index = data.floor.blank})
  return self
end

function data.floor.blank:draw()
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.blank:update(player)
end

function data.floor.blank:interact(player)
end


-- The End --

data.floor.theend = {}

function data.floor.theend.new(depth)
  local self = class.floor.new(depth)
  setmetatable(self, {__index = data.floor.theend})
  self.image = love.graphics.newImage("assets/floors/theend.png")
  return self
end

function data.floor.theend:draw()
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.theend:update(player)
end

function data.floor.theend:interact(player)
end


-- Gray --

data.floor.gray = {}

function data.floor.gray.new(depth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/gray.png")
  setmetatable(self, {__index = data.floor.gray})
  return self
end

function data.floor.gray:draw()
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.gray:update(player)
end

function data.floor.gray:interact(player)
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function data.getLevel(levelNumber)
  local floors = {}
  if (levelNumber == 1) then
    table.insert(floors, data.floor.blank.new(0.001))
    table.insert(floors, data.floor.gray.new(0.011))
    table.insert(floors, data.floor.theend.new(0.022))
  else
    print("LD57: Level " .. levelNumber .. " does not exist.")
    table.insert(floors, data.floor.blank.new(1.0))
  end
  local level = class.level.new(floors)
  return level
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return data
