local level = {
  size = 20,
  registry = {
    block = {
      0,
      0,
      0
    },
    player = {
      1,
      1,
      0
    }
  },
  map = { }
}
level.load = function(self, path)
  local image = love.image.newImageData(path)
  local map = { }
  for x = 0, image:getWidth() - 1 do
    for y = 0, image:getHeight() - 1 do
      local r, g, b = image:getPixel(x, y)
      for k, v in pairs(self.registry) do
        do
          local _with_0 = math
          local e = 0.01
          if (_with_0.fuzzy_eq(r, v[1], e)) and (_with_0.fuzzy_eq(g, v[2], e)) and _with_0.fuzzy_eq(b, v[3], e) then
            self:spawn(k, self.size * x, self.size * y)
          end
        end
      end
    end
  end
end
level.spawn = function(self, k, x, y)
  local _exp_0 = k
  if "block" == _exp_0 then
    local conf = {
      position = {
        x = x,
        y = y
      },
      size = {
        w = 24,
        h = 24
      },
      color = {
        0,
        0,
        0
      },
      slime = {
        visible = false,
        dir = { },
        color = {
          1,
          1,
          1
        }
      }
    }
    local id = e.block(conf)
    return world:add(id, x, y, conf.size.w, conf.size.h)
  elseif "player" == _exp_0 then
    local conf = {
      position = {
        x = x,
        y = y
      },
      size = {
        w = 16,
        h = 16
      },
      direction = {
        1
      },
      physics = {
        dx = 0,
        dy = 0,
        frc_x = 10,
        frc_y = 2,
        dir = {
          x = 0,
          y = 0
        },
        speed = 20,
        grounded = false,
        gravity = {
          power = 15,
          mod = 1
        },
        jump = {
          desire = 0,
          force = 5,
          doubled = false
        },
        wall = {
          dir = 0,
          stick = 0
        },
        max_speed = 25,
        dash = {
          power = 6,
          timer = 0,
          cooldown = 3
        },
        coyote = 0
      },
      color = {
        1,
        1,
        0
      },
      player = { },
      shade = {
        1,
        1,
        0
      },
      head = {
        body = sprites.player.body,
        eyes = {
          img = sprites.player.eyes,
          x = x,
          y = y
        },
        s = 1,
        r = 0
      }
    }
    local id = e.player(conf)
    return world:add(id, x, y, conf.size.w, conf.size.h)
  end
end
return level
