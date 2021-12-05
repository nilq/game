level = require("game/level")
local camera = require("game/camera")
local grid = require("grid")
local bar = require("bar")
shack = require("libs/shack")
require("game/sprites")
do
  local _with_0 = love.audio
  sounds = {
    hop = _with_0.newSource("res/sound/hop.wav", "static"),
    landing = _with_0.newSource("res/sound/landing.wav", "static"),
    steps = _with_0.newSource("res/sound/stepz.wav", "static"),
    dash = _with_0.newSource("res/sound/dash.wav", "static"),
    kick = _with_0.newSource("res/sound/kick.wav", "static"),
    kick_b = _with_0.newSource("res/sound/kick.wav", "static"),
    splat = _with_0.newSource("res/sound/splat.wav", "static"),
    music = _with_0.newSource("res/music/viking_music.mp3", "stream"),
    ouch = _with_0.newSource("res/sound/ouch.wav", "static"),
    crunch = _with_0.newSource("res/sound/crunch.wav", "static"),
    door = _with_0.newSource("res/sound/door.wav", "static")
  }
end
sounds.music:setLooping(true)
sounds.music:setVolume(0.4)
GEN = 0
LEVEL = 0
game = {
  dt = 0,
  time = 0,
  tile_scale = 24,
  editor = false,
  god = false,
  death = false,
  death_timer = 0,
  level = 0,
  level_timer = 0
}
love.graphics.setBackgroundColor(255 / 255, 157 / 255, 90 / 255)
game.load = function(self)
  GEN = GEN + 1
  print("new e?", #e)
  if #e then
    local b = #e * 3
    for i = 1, #e do
      e.delete(i)
    end
    for i = 1, 10000 do
      e.nothing({ })
    end
    for i = 1, #e do
      e.delete(i)
    end
    print("after:", #e)
  end
  level:load("levels/" .. tostring(LEVEL) .. ".png")
  self.camera = camera(0, 0, 2.5, 2.5, 0)
  self.grid = grid.make()
  self.bar = bar.make()
  self.bar:add({
    sprite = sprites.player.body,
    name = "block"
  })
  sounds.music:play()
  self.death = false
  self.death_timer = 0
end
game.restart_level = function(self)
  love.load()
  return collectgarbage()
end
game.update = function(self, dt)
  self.dt = dt
  self.time = self.time + dt
  self.death_timer = math.max(0, self.death_timer - dt)
  self.level_timer = math.max(0, self.level_timer - dt)
  if self.death and self.death_timer == 0 then
    self:restart_level()
  end
  if self.next_level and self.level_timer == 0 then
    self.next_level = false
    LEVEL = LEVEL + 1
    self:restart_level()
  end
  if self.editor then
    self.bar:update(dt)
  end
  s(s.player, s.cloud)
  shack:update(dt)
  if self.editor then
    self.camera.sx = math.cerp(self.camera.sx, 1.2, dt * 10)
    self.camera.sy = math.cerp(self.camera.sy, 1.2, dt * 10)
  else
    if self.death then
      self.camera.sx = math.cerp(self.camera.sx, 4.5, dt * 4)
      self.camera.sy = math.cerp(self.camera.sy, 4.5, dt * 4)
    else
      self.camera.sx = math.cerp(self.camera.sx, 2.5, dt * 10)
      self.camera.sy = math.cerp(self.camera.sy, 2.5, dt * 10)
    end
  end
end
game.draw = function(self)
  self.camera:set()
  if self.editor then
    self.grid:draw()
  end
  shack:apply()
  s(s.sprite, s.block, s.head)
  if self.editor then
    self.grid:draw_highlight()
  end
  self.camera:unset()
  if self.editor then
    self.bar:draw()
  end
  if self.death then
    do
      local _with_0 = love.graphics
      _with_0.setColor(173 / 255, 50 / 255, 50 / 255, 1 - self.death_timer)
      _with_0.rectangle("fill", 0, 0, _with_0.getWidth(), _with_0.getHeight())
    end
  end
  if self.level_timer > 0 then
    do
      local _with_0 = love.graphics
      _with_0.setColor(0.2, 0.2, 0.2, 1 - self.level_timer)
      _with_0.rectangle("fill", 0, 0, _with_0.getWidth(), _with_0.getHeight())
      return _with_0
    end
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
