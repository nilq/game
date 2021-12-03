export level  = require "game/level"
camera = require "game/camera"

grid   = require "grid"
bar    = require "bar"

export shack = require "libs/shack"

require "game/sprites"

export game = {
  dt: 0
  time: 0 -- incrementing forever!!!
  tile_scale: 24
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

game.update = (dt) =>
  @dt = dt
  @time += dt

  @bar\update dt

  s(s.player)

  shack\update dt

game.draw = =>
  @camera\set!

  @grid\draw!

  shack\apply!

  s(s.block, s.head)

  @grid\draw_highlight!

  @camera\unset!

  @bar\draw!

game.press = (key) =>
  @bar\press key

game.mousepressed = (x, y, button, is_touch) =>
  @bar\click x, y, button, is_touch

game.textinput = (t) =>
  @bar\textinput t

game
