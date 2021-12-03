local level = require("game/level")
local camera = require("game/camera")
shack = require("libs/shack")
require("game/sprites")
game = {
  dt = 0,
  time = 0
}
love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
game.load = function(self)
  for i = 1, #e do
    e.delete(i)
  end
  level:load("levels/test.png")
  self.camera = camera(0, 0, 2.5, 2.5, 0)
end
game.update = function(self, dt)
  self.dt = dt
  self.time = self.time + dt
  s(s.player)
  return shack:update(dt)
end
game.draw = function(self)
  self.camera:set()
  shack:apply()
  s(s.block, s.head)
  return self.camera:unset()
end
return game
