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
      1,
      0
    }
  },
  map = { },
  min_x = nil,
  min_y = nil,
  max_x = nil,
  max_y = nil
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
  self:spawn(id, x * level.size, y * level.size)
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
  local ref = self.map[x][y].ref
  ref:remove()
  for i, v in ipairs(e) do
    if v == ref then
      e.delete(i)
      break
    end
  end
  self.map[x][y] = nil
end
level.export_map = function(self, path)
  local width = self.max_x - self.min_x + 1
  local height = self.max_y - self.min_y + 1
  local level_img = love.image.newImageData(width, height)
  for x = 0, self.max_x do
    local _continue_0 = false
    repeat
      if not (self.map[x]) then
        _continue_0 = true
        break
      end
      for y = 0, self.max_y do
        local _continue_1 = false
        repeat
          if not (self.map[x][y]) then
            _continue_1 = true
            break
          end
          local color = game.level.registry[self.map[x][y].id]
          local new_x = x - self.min_x
          local new_y = y - self.min_y
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
  if not (love.filesystem.getInfo("maps")) then
    love.filesystem.createDirectory("maps")
  end
  return level_img:encode("png", path)
end
return level
