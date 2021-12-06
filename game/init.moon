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
    splat:   .newSource "res/sound/splat.wav", "static"
    music:   .newSource "res/music/viking_music.mp3", "stream"
    ouch:    .newSource "res/sound/ouch.wav", "static"
    crunch:  .newSource "res/sound/crunch.wav", "static"
    door:    .newSource "res/sound/door.wav", "static"
  }

sounds.music\setLooping true
sounds.music\setVolume 0.4

export GEN = 0
export LEVEL = 0

night_levels = { [4]: true, [5]: true }

export game = {
  dt: 0
  time: 0 -- incrementing forever!!!
  tile_scale: 24
  editor: false
  god: false
  death: false
  death_timer: 0
  level: 0
  level_timer: 0
  sunset_y: 0
}

love.graphics.setBackgroundColor 255 / 255, 157 / 255, 90 / 255

game.load = =>
  unless night_levels[LEVEL]
    love.graphics.setBackgroundColor 255 / 255, 157 / 255, 90 / 255
  else
    love.graphics.setBackgroundColor 15 / 255, 10 / 255, 57 / 255

  GEN += 1
  print "new e?", #e

  if #e
    b = #e * 3

    for i = 1, #e
      e.delete i

    for i = 1, 10000
      e.nothing {}

    for i = 1, #e
      e.delete i

    print "after:", #e

  unless LEVEL == 6
    level\load "levels/#{LEVEL}.png"

  @camera = camera 0, 0, 2.5, 2.5, 0
  @grid   = grid.make!
  @bar    = bar.make!

  @bar\add
    sprite: sprites.player.body
    name: "block"

  sounds.music\play!

  @death = false
  @death_timer = 0

  @sunset_y = @camera.y - @camera\height! / 4
  @osy = level.player_coords.y - @camera\height! / 3
  @osx = @camera.x - @camera\width! / 3

game.restart_level = =>
  export world = bump.newWorld!
  @load!
  collectgarbage!

game.update = (dt) =>
  @dt = dt
  @time += dt

  @death_timer = math.max 0, @death_timer - dt
  @level_timer = math.max 0, @level_timer - dt

  @sunset_y = math.lerp @sunset_y, @camera.y - @camera\height! / 4, dt * 4
  --@osy = math.cerp @osy, @sunset_y, dt * 10
  @osx = @camera.x - @camera\width! / 3

  if @death and @death_timer == 0
    @restart_level!

  if @next_level and @level_timer == 0
    @next_level = false
    LEVEL += 1
    @restart_level!

  @bar\update dt if @editor

  s(s.player, s.cloud)

  shack\update dt

  if @editor
    @camera.sx = math.cerp @camera.sx, 1.2, dt * 10
    @camera.sy = math.cerp @camera.sy, 1.2, dt * 10
  else if @death
    @camera.sx = math.cerp @camera.sx, 4.5, dt * 4
    @camera.sy = math.cerp @camera.sy, 4.5, dt * 4
  else
    @camera.sx = math.cerp @camera.sx, 2.5, dt * 10
    @camera.sy = math.cerp @camera.sy, 2.5, dt * 10

game.draw = =>
  return unless @camera

  @camera\set!

  @grid\draw! if @editor

  shack\apply!

  unless night_levels[LEVEL]
    with love.graphics

      .setColor 1, 1, 0, 0.6
      .draw sprites.sun, @osx, @osy + (@osy - @sunset_y) / 10 - @camera\height! / 10, 0, 0.5, 0.5

      .setColor 1, 1, 1
      .draw sprites.clouds[1], @osx, @osy + (@osy - @sunset_y) / 10 + @camera\height! / 8, 0, 2.5, 2.5
      .draw sprites.clouds[2], @osx + 90, @osy + (@osy - @sunset_y) / 10 + @camera\height! / 7, 0, 2.5, 2.5

  s(s.sprite, s.block, s.head)

  @grid\draw_highlight! if @editor

  @camera\unset!

  @bar\draw! if @editor

  if @death
    with love.graphics
      .setColor 173 / 255, 50 / 255, 50 / 255, 1 - @death_timer
      .rectangle "fill", 0, 0, .getWidth!, .getHeight!

  if @level_timer > 0
    with love.graphics
      .setColor 0.2, 0.2, 0.2, 1 - @level_timer
      .rectangle "fill", 0, 0, .getWidth!, .getHeight!

  if LEVEL == 6
    with love.graphics
      .setColor 0, 0, 0
      .rectangle "fill", 0, 0, .getWidth!, .getHeight!

      .setColor 1, 1, 1
      .draw sprites.win, .getWidth! / 2 - sprites.win\getWidth! / 2, .getHeight! / 2 - sprites.win\getHeight! / 2

game.press = (key) =>
  @bar\press key

game.mousepressed = (x, y, button, is_touch) =>
  @bar\click x, y, button, is_touch

game.textinput = (t) =>
  @bar\textinput t

game
