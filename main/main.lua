local view = require("utils.view")


-- / --------- \
-- | Callbacks |
-- \ --------- /

function love.load()
  view.setDimensions(256, 256)
end

function love.draw()
  love.graphics.push("all")
  view.origin()
  love.graphics.line(20, 40, 60, 80)
  love.graphics.pop()
end
