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
local night_levels = {
  [4] = true,
  [5] = true
}
game = {
  dt = 0,
  time = 0,
  tile_scale = 24,
  editor = false,
  god = false,
  death = false,
  death_timer = 0,
  level = 0,
  level_timer = 0,
  sunset_y = 0
}
love.graphics.setBackgroundColor(255 / 255, 157 / 255, 90 / 255)
game.load = function(self)
  if not (night_levels[LEVEL]) then
    love.graphics.setBackgroundColor(255 / 255, 157 / 255, 90 / 255)
  else
    love.graphics.setBackgroundColor(15 / 255, 10 / 255, 57 / 255)
  end
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
  if not (LEVEL == 6) then
    level:load("levels/" .. tostring(LEVEL) .. ".png")
  end
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
  self.sunset_y = self.camera.y - self.camera:height() / 4
  self.osy = level.player_coords.y - self.camera:height() / 3
  self.osx = self.camera.x - self.camera:width() / 3
end
game.restart_level = function(self)
  world = bump.newWorld()
  self:load()
  return collectgarbage()
end
game.update = function(self, dt)
  self.dt = dt
  self.time = self.time + dt
  self.death_timer = math.max(0, self.death_timer - dt)
  self.level_timer = math.max(0, self.level_timer - dt)
  self.sunset_y = math.lerp(self.sunset_y, self.camera.y - self.camera:height() / 4, dt * 4)
  self.osx = self.camera.x - self.camera:width() / 3
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
  if not (self.camera) then
    return 
  end
  self.camera:set()
  if self.editor then
    self.grid:draw()
  end
  shack:apply()
  if not (night_levels[LEVEL]) then
    do
      local _with_0 = love.graphics
      _with_0.setColor(1, 1, 0, 0.6)
      _with_0.draw(sprites.sun, self.osx, self.osy + (self.osy - self.sunset_y) / 10 - self.camera:height() / 10, 0, 0.5, 0.5)
      _with_0.setColor(1, 1, 1)
      _with_0.draw(sprites.clouds[1], self.osx, self.osy + (self.osy - self.sunset_y) / 10 + self.camera:height() / 8, 0, 2.5, 2.5)
      _with_0.draw(sprites.clouds[2], self.osx + 90, self.osy + (self.osy - self.sunset_y) / 10 + self.camera:height() / 7, 0, 2.5, 2.5)
    end
  end
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
    end
  end
  if LEVEL == 6 then
    do
      local _with_0 = love.graphics
      _with_0.setColor(0, 0, 0)
      _with_0.rectangle("fill", 0, 0, _with_0.getWidth(), _with_0.getHeight())
      _with_0.setColor(1, 1, 1)
      _with_0.draw(sprites.win, _with_0.getWidth() / 2 - sprites.win:getWidth() / 2, _with_0.getHeight() / 2 - sprites.win:getHeight() / 2)
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
