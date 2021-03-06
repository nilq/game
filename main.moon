jit.opt.start 3, '-loop', 'maxtrace=5000', 'hotloop=100'

--require "libs/autobatch"

export e, c, s = unpack (require "libs/ecs")

e.nothing = {} -- for purging entities!!

require "game/ecs/components"
require "game/ecs/entity/player"
require "game/ecs/entity/block"
require "game/ecs/entity/spike"
require "game/ecs/entity/house"
require "game/ecs/entity/cloud"
require "game/ecs/entity/door"

require "game/ecs/system/block"
require "game/ecs/system/head"
require "game/ecs/system/sprite"
require "game/ecs/system/cloud"

baton   = require "libs/baton"
console = require "libs/console"

export bump = require "libs/bump"
export trail = require "libs/trail"

state = require "game"
menu = require "menu"

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

  console.defineCommand "editor", "Toggle level-editor.", ->
    console.i "Level editor: " .. tostring not state.editor
    state.editor = not state.editor
    state.god = state.editor

  console.defineCommand "god", "Toggle god-mode.", ->
    console.i "God mode!!!: " .. tostring not state.god
    state.god = not state.god

love.update = (dt) ->
  if menu.timer > 0
    menu\update dt
  else
    if not menu.loaded
      state\load!
      menu.loaded = true
      return

    console.update dt
    input\update dt
    state\update dt
    trail\update dt

love.draw = ->
  with love.graphics
    .setColor 0, 0, 0
    .print "FPS " .. love.timer.getFPS!, 10, 10

  if menu.timer > 0
    menu\draw!
  else
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

  state\press key if menu.timer == 0

love.keyreleased = ->
  return

love.textinput = (t) ->
  console.textinput t
  state\textinput t if menu.timer == 0

love.mousepressed = (x, y, button) ->
  console.mousepressed x, y, button
  state\mousepressed x, y, button if menu.timer == 0

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
