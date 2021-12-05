jit.opt.start(3, '-loop', 'maxtrace=5000', 'hotloop=100')
e, c, s = unpack((require("libs/ecs")))
e.nothing = { }
require("game/ecs/components")
require("game/ecs/entity/player")
require("game/ecs/entity/block")
require("game/ecs/entity/spike")
require("game/ecs/entity/house")
require("game/ecs/entity/cloud")
require("game/ecs/entity/door")
require("game/ecs/system/block")
require("game/ecs/system/head")
require("game/ecs/system/sprite")
require("game/ecs/system/cloud")
local baton = require("libs/baton")
local console = require("libs/console")
bump = require("libs/bump")
local state = require("game")
input = baton.new({
  controls = {
    left = {
      "key:left",
      "axis:leftx-",
      "button:dpleft"
    },
    right = {
      "key:right",
      "axis:leftx+",
      "button:dpright"
    },
    up = {
      "key:up",
      "key:z",
      "axis:lefty-",
      "button:dpup"
    },
    down = {
      "key:down",
      "axis:lefty+",
      "button:dpdown"
    },
    dash = {
      "key:lshift",
      "button:rightshoulder"
    }
  },
  pairs = {
    move = {
      "left",
      "right",
      "up",
      "down"
    }
  },
  joystick = love.joystick.getJoysticks()[1]
})
love.load = function()
  world = bump.newWorld()
  console.load()
  state:load()
  console.defineCommand("editor", "Toggle level-editor.", function()
    console.i("Level editor: " .. tostring(not state.editor))
    state.editor = not state.editor
    state.god = state.editor
  end)
  return console.defineCommand("god", "Toggle god-mode.", function()
    console.i("God mode!!!: " .. tostring(not state.god))
    state.god = not state.god
  end)
end
love.update = function(dt)
  console.update(dt)
  input:update()
  return state:update(dt)
end
love.draw = function()
  do
    local _with_0 = love.graphics
    _with_0.setColor(0, 0, 0)
    _with_0.print("FPS " .. love.timer.getFPS(), 10, 10)
  end
  state:draw()
  return console.draw()
end
love.keypressed = function(key)
  if console.keypressed(key) then
    return 
  end
  local _exp_0 = key
  if "r" == _exp_0 then
    love.load()
  elseif "escape" == _exp_0 then
    love.event.quit()
  end
  return state:press(key)
end
love.keyreleased = function() end
love.textinput = function(t)
  console.textinput(t)
  return state:textinput(t)
end
love.mousepressed = function(x, y, button)
  console.mousepressed(x, y, button)
  return state:mousepressed(x, y, button)
end
math.fuzzy_eq = function(a, b, eps)
  return a == b or (math.abs(a - b)) < eps
end
math.cerp = function(a, b, t)
  local f = (1 - math.cos((t * math.pi))) * 0.5
  return a * (1 - f) + b * f
end
math.lerp = function(a, b, t)
  return a + (b - a) * t
end
math.dist = function(pa, pb)
  return ((pb.x - pa.x) ^ 2 + (pb.y - pa.y) ^ 2) ^ 0.5
end
math.sign = function(a)
  if a < 0 then
    return -1
  else
    if a > 0 then
      return 1
    else
      return 0
    end
  end
end
