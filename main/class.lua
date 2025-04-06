local class = {}
local state = require("state")


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
  uniform float speed;
  uniform float minDepth;
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 _) {
    vec4 texcolor = Texel(tex, texture_coords);
    texcolor.r *= speed;
    return texcolor * color;
 }
]])
class.surface._carveShader = love.graphics.newShader([[
  uniform float speed;
  uniform float maxDepth;
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 _) {
    vec4 texcolor = Texel(tex, texture_coords);
    texcolor.r *= speed;
    return texcolor * color;
 }
]])
class.surface._clampShader = love.graphics.newShader([[
  uniform float minDepth;
  uniform float maxDepth;
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 _) {
    vec4 texcolor = Texel(tex, texture_coords);
    texcolor.r = min(max(texcolor.r, minDepth), maxDepth);
    return texcolor * color;
 }
]])

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

function class.surface:uncarve(speed, minDepth)
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  class.surface._uncarveShader:send("speed", speed)
  love.graphics.setShader(class.surface._uncarveShader)
  love.graphics.setBlendMode("subtract")
  love.graphics.setColor(1/255, 0, 0)
  love.graphics.rectangle("fill", -64, -64, 512, 512)
  love.graphics.pop()
end

function class.surface:carve(x, y, speed, maxDepth)
  love.graphics.push("all")
  love.graphics.setCanvas(self.canvas)
  class.surface._carveShader:send("speed", speed)
  love.graphics.setShader(class.surface._carveShader)
  love.graphics.setBlendMode("add")
  love.graphics.setColor(1/255, 0, 0)
  for i=1,23 do
    love.graphics.circle("fill", x + 64, y + 64, 80 - i ^ 1.4)
  end
  love.graphics.pop()
end

function class.surface:clamp(minDepth, maxDepth)
  love.graphics.push("all")
  local canvas = love.graphics.newCanvas(512, 512, {format="r16"})
  love.graphics.setCanvas(canvas)
  class.surface._clampShader:send("minDepth", minDepth)
  class.surface._clampShader:send("maxDepth", maxDepth)
  love.graphics.setShader(class.surface._clampShader)
  love.graphics.draw(self.canvas)
  love.graphics.setShader()
  self.canvas = canvas
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
class.player._shader = love.graphics.newShader([[
  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texcolor = Texel(tex, texture_coords);
    float brightness = (texcolor.r + texcolor.g + texcolor.b) / 3.0;
    float posX = screen_coords.x;
    float posY = screen_coords.y;
    if (mod(posX + 2, 8) < 4 || mod(posY + 2, 8) < 4) {
      discard;
    }
    return texcolor * color;
 }
]])

function class.player.new(x, y)
  local self = {}
  self.canvas = love.graphics.newCanvas(384, 384)
  self.playerImage = love.graphics.newImage("assets/player/player.png")
  self.shellImage = love.graphics.newImage("assets/player/player_shell.png")
  self.x = x
  self.y = y
  self.visible = true
  self.velX = 0.0
  self.velY = 0.0
  self.lastX = x
  self.lastY = y
  setmetatable(self, {__index = class.player})
  return self
end

function class.player:draw()
  local length = math.sqrt(self.velX ^ 2 + self.velY ^ 2)
  if length ~= length or length == 0 then length = 1 end
  love.graphics.push("all")
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  local x = self.x + self.velX * 3.0 - 16
  local y = self.y + self.velY * 3.0 - 16
  if self.visible then
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.draw(self.playerImage, x, y)
  end
  love.graphics.setColor(1.0, 1.0, 1.0, 0.2)
  love.graphics.setShader(class.player._shader)
  love.graphics.draw(self.shellImage, self.x - 16, self.y - 16)
  love.graphics.pop()
  love.graphics.draw(self.canvas)
end

function class.player:move(x, y)
  self.lastX = self.x
  self.lastY = self.y
  self.velX = self.velX / 1.1
  self.velY = self.velY / 1.1
  self.velX = math.min(0.8, math.max(-0.8, self.velX + x * 0.1))
  self.velY = math.min(0.8, math.max(-0.8, self.velY + y * 0.1))
  self.x = self.x + self.velX
  self.y = self.y + self.velY
  -- if self.x > 0.5 and self.y > 0.5 then
  --   self.image = love.graphics.newImage("assets/player/down_right.png")
  -- elseif self.x > 0.5 and self.y < -0.5 then
  --   self.image = love.graphics.newImage("assets/player/up_right.png")
  -- elseif self.x < -0.5 and self.y > 0.5 then
  --   self.image = love.graphics.newImage("assets/player/down_left.png")
  -- elseif self.x < -0.5 and self.y < -0.5 then
  --   self.image = love.graphics.newImage("assets/player/up_left.png")
  -- elseif self.x > 0.5 then
  --   self.image = love.graphics.newImage("assets/player/right.png")
  -- elseif self.x < -0.5 then
  --   self.image = love.graphics.newImage("assets/player/left.png")
  -- elseif self.y > 0.5 then
  --   self.image = love.graphics.newImage("assets/player/down.png")
  -- elseif self.y < -0.5 then
  --   self.image = love.graphics.newImage("assets/player/up.png")
  -- end
  if self.x < 12 then self.x = 12 end
  if self.y < 12 then self.y = 12 end
  if self.x > 372 then self.x = 372 end
  if self.y > 372 then self.y = 372 end
end


-- / ----- \ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Level | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- \ ----- / -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.level = {}

function class.level.new(floors, minDepth, maxDepth)
  local self = {}
  self.floors = floors
  self.minDepth = minDepth
  self.maxDepth = maxDepth
  self.win = false
  setmetatable(self, {__index = class.level})
  return self
end

function class.level:_getFloor(surface, x, y)
  local image = surface.canvas:newImageData() -- Slow!
  local depth = image:getPixel(x + 64, y + 64)
  local floor = nil
  for i=1,#self.floors do
    if self.floors[i].depth >= depth then
      floor = self.floors[i]
    end
  end
  return floor
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
  for i=1,#self.floors do
    self.floors[i]:update()
  end
  local playerFloor = self:_getFloor(surface, player.x, player.y)
  if playerFloor then
    playerFloor:updatePlayer(player, self)
  end
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
