jit.opt.start 3, '-loop', 'maxtrace=5000', 'hotloop=100'

require "libs/autobatch"

export e, c, s = unpack (require "libs/ecs")

require "game/ecs/components"
require "game/ecs/entity/player"
require "game/ecs/entity/block"

require "game/ecs/system/block"
require "game/ecs/system/head"

baton   = require "libs/baton"
console = require "libs/console"
bump    = require "libs/bump"

state = require "game"

export input = baton.new
  controls:
    left:  { "key:left",           "axis:leftx-", "button:dpleft"  }
    right: { "key:right",          "axis:leftx+", "button:dpright" }
    up:    { "key:up", "key:z",    "axis:lefty-", "button:dpup"    }
    down:  { "key:down",           "axis:lefty+", "button:dpdown"  }
    dash:  { "key:lshift", "button:rightshoulder" }

  pairs:
    move: { "left", "right", "up", "down" }

  joystick: love.joystick.getJoysticks![1]

love.load = ->
  export world = bump.newWorld!

  console.load!
  state\load!

love.update = (dt) ->
  console.update dt
  input\update!
  state\update dt

love.draw = ->
  with love.graphics
    .setColor 0, 0, 0
    .print "FPS " .. love.timer.getFPS!, 10, 10

    .setColor 0, 0.8, 0
    .print "<arrow keys to move>", 10, 35
    .print "<shift to dash>", 10, 50
    .print "<wall jump pls>", 10, 65

  state\draw!
  console.draw!

love.keypressed = (key) ->
  if console.keypressed key
    return

  switch key
    when "r"
      love.load!
    when "escape"
      love.event.quit!


love.keyreleased = ->
  return

love.textinput = (t) ->
  console.textinput t

love.mousepressed = (x, y, button) ->
  console.mousepressed x, y, button


-- weird shit:

math.fuzzy_eq = (a, b, eps) ->
  a == b or (math.abs a - b) < eps

math.cerp = (a, b, t) ->
  f = (1 - math.cos (t * math.pi)) * 0.5
  a * (1 - f) + b * f

math.lerp = (a, b, t) -> a + (b - a) * t

math.dist = (pa, pb) ->
  ((pb.x - pa.x)^2 + (pb.y - pa.y)^2)^0.5

math.sign = (a) ->
  if a < 0
    -1
  else if a > 0
    1
  else
    0