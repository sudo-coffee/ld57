local class = {}


-- / ------ \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Player | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------ / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.player = {}

function class.player.new()
  local self = {}
  setmetatable(self, {__index = class.player})
  return self
end


-- / ----- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | World | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ----- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.world = {}

function class.world.new(floors)
  local self = {}
  self.floors = floors
  self.stencil = nil
  setmetatable(self, {__index = class.world})
  return self
end

function class.world.draw()
  -- TBD
end

function class.world.addFloor()
  -- TBD
end

function class.world.sortFloors()
  -- TBD
end


-- / ----- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Floor | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ----- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.floor = {}

function class.floor.new(depth)
  local self = {}
  self.depth = 0
  setmetatable(self, {__index = class.floor})
  return self
end

-- override
function class.floor.draw()
end

-- override
function class.floor.update(player)
end

-- override
function class.floor.interract(player)
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return class
