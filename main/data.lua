local class = require("class")
local view = require("utils.view")
local data = {}
data.floor = {}
data.level = {}


-- / ------ \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Floors | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------ / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Blank --

data.floor.blank = {}

function data.floor.blank.new(depth, nextMaxDepth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/blank.png")
  self.nextMaxDepth = nextMaxDepth
  setmetatable(self, {__index = data.floor.blank})
  return self
end

function data.floor.blank:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.blank:update(player, level)
end

function data.floor.blank:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(0.0)
  player.audioSourceA:setVolume(1.0)
  player.audioSourceB:setVolume(0.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = false
  player.hidden = false
  level.maxDepth = self.nextMaxDepth
end

-- Above --

data.floor.above = {}

function data.floor.above.new(depth)
  local self = class.floor.new(depth)
  self.drawShadow = false
  self.image = love.graphics.newImage("assets/floors/blank.png")
  setmetatable(self, {__index = data.floor.above})
  return self
end

function data.floor.above:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.above:update(player, level)
end

function data.floor.above:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(0.0)
  player.audioSourceA:setVolume(1.0)
  player.audioSourceB:setVolume(0.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = false
  player.hidden = false
  if player.ascend then
    player.newgame = true
  end
end


-- The End --

data.floor.theend = {}

function data.floor.theend.new(depth)
  local self = class.floor.new(depth)
  self.drawShadow = false
  -- self.buttonPressed = false
  setmetatable(self, {__index = data.floor.theend})
  self.image = love.graphics.newImage("assets/floors/theend.png")
  return self
end

function data.floor.theend:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.theend:update(player, level)
  -- if player.ascend and not self.buttonPressed then
  --   self.image = love.graphics.newImage("assets/floors/reset_pressed.png")
  --   self.buttonPressed = true
  -- end
end

function data.floor.theend:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(1.0)
  player.audioSourceA:setVolume(0.0)
  player.audioSourceB:setVolume(0.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = true
  player.hidden = false
end


-- Gray --

data.floor.gray = {}

function data.floor.gray.new(depth, nextMaxDepth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/gray.png")
  self.map = love.image.newImageData("assets/floors/gray_map.png")
  self.nextMaxDepth = nextMaxDepth
  setmetatable(self, {__index = data.floor.gray})
  return self
end

function data.floor.gray:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.gray:update(player, level)
end

function data.floor.gray:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(0.0)
  player.audioSourceA:setVolume(1.0)
  player.audioSourceB:setVolume(1.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = false
  if self.map:getPixel(player.x, player.y) == 0 then
    player.x, player.y = player.lastX, player.lastY
  end
  if self.map:getPixel(player.x, player.y) == 0 then
    player.hidden = true
  else
    player.hidden = false
    level.maxDepth = self.nextMaxDepth
  end
end


-- Maze A --

data.floor.mazea = {}

function data.floor.mazea.new(depth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/maze_a.png")
  self.map = love.image.newImageData("assets/floors/maze_a_map.png")
  setmetatable(self, {__index = data.floor.mazea})
  return self
end

function data.floor.mazea:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.mazea:update(player, level)
end

function data.floor.mazea:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(0.0)
  player.audioSourceA:setVolume(1.0)
  player.audioSourceB:setVolume(1.0)
  player.audioSourceC:setVolume(1.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = false
  if self.map:getPixel(player.x, player.y) == 0 then
    player.x, player.y = player.lastX, player.lastY
  end
  if self.map:getPixel(player.x, player.y) == 0 then
    player.hidden = true
  else
    player.hidden = false
  end
end


-- Maze B --

data.floor.mazeb = {}

function data.floor.mazeb.new(depth, nextMaxDepth)
  local self = class.floor.new(depth)
  self.image = love.graphics.newImage("assets/floors/maze_b.png")
  self.map = love.image.newImageData("assets/floors/maze_b_map.png")
  self.nextMaxDepth = nextMaxDepth
  setmetatable(self, {__index = data.floor.mazeb})
  return self
end

function data.floor.mazeb:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.mazeb:update(player, level)
end

function data.floor.mazeb:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(0.0)
  player.audioSourceA:setVolume(1.0)
  player.audioSourceB:setVolume(1.0)
  player.audioSourceC:setVolume(1.0)
  player.audioSourceD:setVolume(1.0)
  player.descend = false
  if self.map:getPixel(player.x, player.y) == 0 then
    player.x, player.y = player.lastX, player.lastY
  end
  if self.map:getPixel(player.x, player.y) == 0 then
    player.hidden = true
  elseif self.map:getPixel(player.x, player.y) == 1 then
    player.hidden = false
  else
    player.hidden = false
    level.maxDepth = self.nextMaxDepth
  end
end

-- Reset A --

data.floor.reseta = {}

function data.floor.reseta.new(depth, nextMinDepth, raiseAmount)
  local self = class.floor.new(depth)
  self.drawShadow = false
  self.nextMinDepth = nextMinDepth
  -- self.buttonPressed = false
  self.raiseAmount = raiseAmount
  setmetatable(self, {__index = data.floor.reseta})
  self.image = love.graphics.newImage("assets/floors/reset.png")
  self.map = love.image.newImageData("assets/floors/reset_map.png")
  return self
end

function data.floor.reseta:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.reseta:update(player, level)
  -- if player.ascend and not self.buttonPressed then
  --   self.image = love.graphics.newImage("assets/floors/reset_pressed.png")
  --   self.buttonPressed = true
  -- end
end

function data.floor.reseta:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(1.0)
  player.audioSourceA:setVolume(0.0)
  player.audioSourceB:setVolume(0.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = true
  player.hidden = false
  if self.map:getPixel(player.x, player.y) == 1 then
    level.minDepth = self.nextMinDepth
    player.ascend = true
    player.raise = self.raiseAmount
  end
end

-- Reset B --

data.floor.resetb = {}

function data.floor.resetb.new(depth, nextMinDepth, raiseAmount)
  local self = class.floor.new(depth)
  self.drawShadow = false
  self.nextMinDepth = nextMinDepth
  -- self.buttonPressed = false
  self.raiseAmount = raiseAmount
  setmetatable(self, {__index = data.floor.resetb})
  self.image = love.graphics.newImage("assets/floors/reset.png")
  self.map = love.image.newImageData("assets/floors/reset_map.png")
  return self
end

function data.floor.resetb:draw()
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.image)
  love.graphics.pop()
end

function data.floor.resetb:update(player, level)
  -- if player.ascend and not self.buttonPressed then
  --   self.image = love.graphics.newImage("assets/floors/reset_pressed.png")
  --   self.buttonPressed = true
  -- end
end

function data.floor.resetb:updatePlayer(player, level)
  player.audioSourceEnd:setVolume(1.0)
  player.audioSourceA:setVolume(0.0)
  player.audioSourceB:setVolume(0.0)
  player.audioSourceC:setVolume(0.0)
  player.audioSourceD:setVolume(0.0)
  player.descend = false
  player.hidden = false
  if self.map:getPixel(player.x, player.y) == 1 then
    level.minDepth = self.nextMinDepth
    player.ascend = true
    player.raise = self.raiseAmount
  end
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function data.getLevel(levelNumber)
  local level
  if (levelNumber == 1) then
    local floors = {}
    table.insert(floors, data.floor.above.new(0.001))
    table.insert(floors, data.floor.blank.new(0.141, 0.180))
    table.insert(floors, data.floor.gray.new(0.181, 0.280))
    table.insert(floors, data.floor.mazea.new(0.241))
    table.insert(floors, data.floor.mazeb.new(0.281, 1.0))
    table.insert(floors, data.floor.theend.new(0.441))
    table.insert(floors, data.floor.reseta.new(0.581, 0.000, 0.100))
    table.insert(floors, data.floor.resetb.new(1.000, 0.000, 0.100))
    level = class.level.new(floors, 0.140, 1.000)
  else
    print("LD57: Level " .. levelNumber .. " does not exist.")
    local floors = {}
    table.insert(floors, data.floor.blank.new(1.0))
    level = class.level.new(floors, 0.000, 1.000)
  end
  return level
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return data
