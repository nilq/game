local level = {
  size = 24,
  registry = {
    block = {
      0,
      0,
      0
    },
    player = {
      1,
      243 / 255,
      0
    },
    spike = {
      1,
      0,
      0
    },
    house = {
      0,
      0,
      1
    },
    dont = {
      102 / 255,
      57 / 255,
      49 / 255
    },
    dirt = {
      138 / 255,
      111 / 255,
      48 / 255
    },
    grass = {
      152 / 255,
      229 / 255,
      80 / 255
    },
    nothing_dirt = {
      132 / 255,
      126 / 255,
      135 / 255
    },
    cloud = {
      155 / 255,
      173 / 255,
      183 / 255
    },
    snow = {
      91 / 255,
      110 / 255,
      225 / 255
    },
    bush = {
      215 / 255,
      123 / 255,
      186 / 255
    }
  },
  map = { },
  min_x = nil,
  min_y = nil,
  max_x = nil,
  max_y = nil,
  player_coords = {
    x = 0,
    y = 0
  }
}
level.load = function(self, path)
  local image = love.image.newImageData(path)
  local map = { }
  for x = 0, image:getWidth() - 1 do
    map[x] = { }
    for y = 0, image:getHeight() - 1 do
      local r, g, b = image:getPixel(x, y)
      for k, v in pairs(self.registry) do
        do
          local _with_0 = math
          local e = 0.01
          if (_with_0.fuzzy_eq(r, v[1], e)) and (_with_0.fuzzy_eq(g, v[2], e)) and _with_0.fuzzy_eq(b, v[3], e) then
            map[x][y] = self:spawn(k, self.size * x, self.size * y)
          end
        end
      end
    end
  end
  return 0
end
level.spawn = function(self, k, x, y)
  local grass_conf = {
    position = {
      x = x,
      y = y
    },
    size = {
      w = 24,
      h = 24
    },
    sprite = {
      img = sprites.grass_full,
      r = 0
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
  local _exp_0 = k
  if "block" == _exp_0 then
    local conf = grass_conf
    local id = e.block(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "block" == _exp_0 then
    local conf = grass_conf
    local id = e.block(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "grass" == _exp_0 then
    local conf = grass_conf
    conf.sprite.img = sprites.grass_full
    local id = e.block(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "snow" == _exp_0 then
    local conf = grass_conf
    conf.sprite.img = sprites.snow
    local id = e.block(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "dirt" == _exp_0 then
    local conf = grass_conf
    conf.sprite.img = sprites.dirt
    local id = e.block(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "nothing_dirt" == _exp_0 then
    local conf = grass_conf
    conf.sprite.img = sprites.dirt
    local id = e.block(conf)
    return id
  elseif "cloud" == _exp_0 then
    for i = 0, math.random(3, 7) do
      local spr = sprites.clouds[math.random(1, #sprites.clouds)]
      local conf = {
        position = {
          x = x + math.random(-36, 36),
          y = y + math.random(-16, 16)
        },
        size = {
          w = spr:getWidth() * 1.5,
          h = spr:getHeight() * 1.5
        },
        sprite = {
          img = spr
        },
        speed = {
          1
        }
      }
      local id = e.cloud(conf)
    end
    return id
  elseif "dont" == _exp_0 then
    local id = e.nothing({ })
    world:add(id, x, y, 24, 24)
    return id
  elseif "house" == _exp_0 then
    local conf = {
      position = {
        x = x,
        y = y - 75
      },
      size = {
        w = sprites.house:getWidth() * 1.5,
        h = sprites.house:getHeight() * 1.5
      },
      sprite = {
        img = sprites.house
      }
    }
    local id = e.house(conf)
    return id
  elseif "bush" == _exp_0 then
    local conf = {
      position = {
        x = x,
        y = y + 6
      },
      size = {
        w = sprites.bush:getWidth(),
        h = sprites.bush:getHeight()
      },
      sprite = {
        img = sprites.bush
      }
    }
    local id = e.house(conf)
    return id
  elseif "spike" == _exp_0 then
    local conf = {
      position = {
        x = x,
        y = y
      },
      size = {
        w = 24,
        h = 24
      },
      sprite = {
        img = sprites.spikes
      },
      hurts = { }
    }
    local id = e.spike(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  elseif "player" == _exp_0 then
    self.player_coords = {
      x = x,
      y = y
    }
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
        god_frc = 15,
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
        coyote = 0,
        smooth_dir = 0
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
        helmet = {
          img = sprites.player.helmet,
          x = x,
          y = y - 8 * 1.5,
          r = 0
        },
        s = 1,
        r = 0
      }
    }
    local id = e.player(conf)
    world:add(id, x, y, conf.size.w, conf.size.h)
    return id
  end
end
level.add_tile = function(self, x, y, id)
  if self.min_x == nil or x < self.min_x then
    self.min_x = x
  end
  if self.max_x == nil or x > self.max_x then
    self.max_x = x
  end
  if self.min_y == nil or y < self.min_y then
    self.min_y = y
  end
  if self.max_y == nil or y > self.max_y then
    self.max_y = y
  end
  if not (self.map[x]) then
    self.map[x] = { }
  elseif self.map[x][y] then
    if id == self.map[x][y].id or self.map[x][y].id == "player" then
      return false
    end
  end
  local tile = self:spawn(id, x * level.size, y * level.size)
  print("Spawned: " .. id .. " at (" .. (tostring(x)) .. ", " .. (tostring(y)) .. ")")
  self.map[x][y] = {
    id = id,
    ref = tile
  }
  return true
end
level.remove_tile = function(self, x, y)
  if not self.map[x] or not self.map[x][y] then
    return 
  end
  if self.map[x][y].id == "player" then
    return 
  end
  return level:remove_tile_unchecked(x, y)
end
level.remove_tile_unchecked = function(self, x, y)
  local i = self.map[x][y].ref
  e.delete(i)
  world:remove(i)
  self.map[x][y] = nil
end
level.export_map = function(self, path)
  local width = self.max_x - self.min_x + 1
  local height = self.max_y - self.min_y + 1
  local level_img = love.image.newImageData(width, height)
  for x = 0, width - 1 do
    for y = 0, height - 1 do
      level_img:setPixel(x, y, 1, 1, 1)
    end
  end
  local xi = 0
  local yi = 0
  for x = self.min_x, self.max_x do
    local _continue_0 = false
    repeat
      xi = xi + 1
      yi = 0
      if not (self.map[x]) then
        _continue_0 = true
        break
      end
      for y = self.min_y, self.max_y do
        local _continue_1 = false
        repeat
          yi = yi + 1
          if not (self.map[x][y]) then
            _continue_1 = true
            break
          end
          local color = level.registry[self.map[x][y].id]
          local new_x = xi - 1
          local new_y = yi - 1
          level_img:setPixel(new_x, new_y, color[1], color[2], color[3])
          _continue_1 = true
        until true
        if not _continue_1 then
          break
        end
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  level_img:setPixel(self.player_coords.x, self.player_coords.y, level.registry["player"])
  if not (love.filesystem.getInfo("maps")) then
    love.filesystem.createDirectory("maps")
  end
  print(path)
  return level_img:encode("png", path)
end
return level
