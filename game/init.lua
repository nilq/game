level = require("game/level")
local camera = require("game/camera")
local grid = require("grid")
local bar = require("bar")
shack = require("libs/shack")
require("game/sprites")
game = {
  dt = 0,
  time = 0,
  tile_scale = 24,
  editor = false
}
love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
game.load = function(self)
  for i = 1, #e do
    e.delete(i)
  end
  level:load("levels/test.png")
  self.camera = camera(0, 0, 2.5, 2.5, 0)
  self.grid = grid.make()
  self.bar = bar.make()
  return self.bar:add({
    sprite = sprites.player.body,
    name = "block"
  })
end
game.update = function(self, dt)
  self.dt = dt
  self.time = self.time + dt
  if self.editor then
    self.bar:update(dt)
  end
  s(s.player)
  return shack:update(dt)
end
game.draw = function(self)
  self.camera:set()
  if self.editor then
    self.grid:draw()
  end
  shack:apply()
  s(s.block, s.head)
  if self.editor then
    self.grid:draw_highlight()
  end
  self.camera:unset()
  if self.editor then
    return self.bar:draw()
  end
end
game.press = function(self, key)
  return self.bar:press(key)
end
game.mousepressed = function(self, x, y, button, is_touch)
  return self.bar:click(x, y, button, is_touch)
end
game.textinput = function(self, t)
  return self.bar:textinput(t)
end
return game
