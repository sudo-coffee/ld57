local class = {}


-- / ------- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Surface | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.surface = {}
class.surface._current = nil
class.surface._stencilShader = love.graphics.newShader([[
  uniform float depth;
  vec4 effect(vec4 _, Image texture, vec2 texture_coords, vec2 __) {
    if (Texel(texture, texture_coords).r > depth) {
       discard;
    }
    return vec4(1.0);
 }
]])
class.surface._uncarveShader = love.graphics.newShader([[
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 __) {
    vec4 texcolor = Texel(tex, texture_coords);
    texcolor.r /= 256.0;
    return texcolor * color;
 }
]])
class.surface._carveShader = love.graphics.newShader([[
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 __) {
    vec4 texcolor = Texel(tex, texture_coords);
    texcolor.r /= 256.0;
    return texcolor * color;
 }
]])

-- 0.5, 0.4, 0.6
-- 0.546
-- 0.5, 

function class.surface.new()
  local self = {}
  self.canvas = love.graphics.newCanvas(512, 512, {format="r16"})

  -- TESTING
  -- love.graphics.push("all")
  -- love.graphics.setCanvas(self.canvas)
  -- local image = love.graphics.newImage("assets/test_surface.png")
  -- love.graphics.draw(image)
  -- love.graphics.pop()
  -- / TESTING

  setmetatable(self, {__index = class.surface})
  return self
end

function class.surface:initParameters(depth)
  class.surface._current = self
  class.surface._stencilShader:send("depth", depth)
end

function class.surface:uncarve()
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  love.graphics.setShader(class.surface._uncarveShader)
  love.graphics.setBlendMode("subtract")
  love.graphics.setColor(1/255, 0, 0)
  love.graphics.rectangle("fill", -64, -64, 512, 512)
  love.graphics.pop()
end

function class.surface:carve(x, y)
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  love.graphics.setShader(class.surface._carveShader)
  love.graphics.setBlendMode("add")
  love.graphics.setColor(1/255, 0, 0)
  for i=1,23 do
    love.graphics.circle("fill", x + 64, y + 64, 80 - i ^ 1.4)
  end
  love.graphics.pop()
end

function class.surface.shadowStencilFunction()
  love.graphics.setShader(class.surface._stencilShader)
  love.graphics.draw(class.surface._current.canvas, -64, -48)
  love.graphics.setShader()
end

function class.surface.floorStencilFunction()
  love.graphics.setShader(class.surface._stencilShader)
  love.graphics.draw(class.surface._current.canvas, -64, -64)
  love.graphics.setShader()
end


-- / ------ \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Player | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ------ / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.player = {}

function class.player.new(x, y)
  local self = {}
  self.image = love.graphics.newImage("assets/player/down.png")
  self.x = x
  self.y = y
  setmetatable(self, {__index = class.player})
  return self
end

function class.player:draw()
  love.graphics.push("all")
  love.graphics.setColor(1.0, 1.0, 1.0, 0.6)
  love.graphics.draw(self.image, self.x - 8, self.y - 8)
  love.graphics.pop()
end

function class.player:move(x, y)
  self.x = self.x + x
  self.y = self.y + y
  if self.x > 0.5 and self.y > 0.5 then
    self.image = love.graphics.newImage("assets/player/down_right.png")
  elseif self.x > 0.5 and self.y < -0.5 then
    self.image = love.graphics.newImage("assets/player/up_right.png")
  elseif self.x < -0.5 and self.y > 0.5 then
    self.image = love.graphics.newImage("assets/player/down_left.png")
  elseif self.x < -0.5 and self.y < -0.5 then
    self.image = love.graphics.newImage("assets/player/up_left.png")
  elseif self.x > 0.5 then
    self.image = love.graphics.newImage("assets/player/right.png")
  elseif self.x < -0.5 then
    self.image = love.graphics.newImage("assets/player/left.png")
  elseif self.y > 0.5 then
    self.image = love.graphics.newImage("assets/player/down.png")
  elseif self.y < -0.5 then
    self.image = love.graphics.newImage("assets/player/up.png")
  end
end


-- / ----- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Level | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ----- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.level = {}

function class.level.new(floors)
  local self = {}
  self.floors = floors
  setmetatable(self, {__index = class.level})
  return self
end

function class.level:_getFloor(surface, x, y)
  -- WIP
end

function class.level:draw(surface)
  love.graphics.push("all")
  for i=1,#self.floors do
    self.floors[i]:draw()
    surface:initParameters(self.floors[i].depth)
    love.graphics.stencil(surface.shadowStencilFunction)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(0.1, 0.1, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, 384, 384)
    love.graphics.stencil(surface.floorStencilFunction)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.draw(self.floors[i].canvas)
  end
  love.graphics.setStencilTest()
  love.graphics.pop()
end

function class.level:update(surface, player)
  table.sort(self.floors, function(a, b) return a.depth > b.depth end)
end

function class.level:interract(surface, player)
  -- WIP
end


-- / ----- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Floor | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ----- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.floor = {}

function class.floor.new(depth)
  local self = {}
  self.depth = depth
  self.canvas = love.graphics.newCanvas(384, 384)
  setmetatable(self, {__index = class.floor})
  return self
end

-- override
function class.floor:draw()
end

-- override
function class.floor:update(player)
end

-- override
function class.floor:interact(player)
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return class
