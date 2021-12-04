export level  = require "game/level"
camera = require "game/camera"

grid   = require "grid"
bar    = require "bar"

export shack = require "libs/shack"

require "game/sprites"

with love.audio
  export sounds = {
    hop:     .newSource "res/sound/hop.wav", "static"
    landing: .newSource "res/sound/landing.wav", "static"
    steps:   .newSource "res/sound/stepz.wav", "static"
    dash:    .newSource "res/sound/dash.wav", "static"
    kick:    .newSource "res/sound/kick.wav", "static"
    kick_b:  .newSource "res/sound/kick.wav", "static"
    music:   .newSource "res/music/viking_music.mp3", "stream"
  }

sounds.music\setLooping true
sounds.music\setVolume 0.7

export game = {
  dt: 0
  time: 0 -- incrementing forever!!!
  tile_scale: 24
  editor: false
  god: false
}

love.graphics.setBackgroundColor 0.8, 0.8, 0.8

game.load = =>
  for i = 1, #e
    e.delete i

  level\load "levels/test.png"

  @camera = camera 0, 0, 2.5, 2.5, 0
  @grid   = grid.make!
  @bar    = bar.make!

  @bar\add
    sprite: sprites.player.body
    name: "block"

  sounds.music\play!

game.update = (dt) =>
  @dt = dt
  @time += dt

  @bar\update dt if @editor

  s(s.player)

  shack\update dt

  if @editor
    @camera.sx = math.cerp @camera.sx, 1.2, dt * 10
    @camera.sy = math.cerp @camera.sy, 1.2, dt * 10
  else
    @camera.sx = math.cerp @camera.sx, 2.5, dt * 10
    @camera.sy = math.cerp @camera.sy, 2.5, dt * 10


game.draw = =>
  @camera\set!

  @grid\draw! if @editor

  shack\apply!

  s(s.block, s.head)

  @grid\draw_highlight! if @editor

  @camera\unset!

  @bar\draw! if @editor

game.press = (key) =>
  @bar\press key

game.mousepressed = (x, y, button, is_touch) =>
  @bar\click x, y, button, is_touch

game.textinput = (t) =>
  @bar\textinput t

game
