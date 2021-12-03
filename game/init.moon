level     = require "game/level"
camera    = require "game/camera"

export shack = require "libs/shack"

require "game/sprites"

export game = {
  dt: 0
  time: 0 -- incrementing forever!!!
}

love.graphics.setBackgroundColor 0.8, 0.8, 0.8

game.load = =>
  for i = 1, #e
    e.delete i

  level\load "levels/test.png"

  @camera = camera 0, 0, 2.5, 2.5, 0

game.update = (dt) =>
  @dt = dt
  @time += dt

  s(s.player)

  shack\update dt

game.draw = =>
  @camera\set!
  shack\apply!

  s(s.block, s.head)

  @camera\unset!

game
