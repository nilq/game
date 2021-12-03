local utf8 = require("utf8")
local make
make = function()
  local bar = {
    x = 0,
    y = 0,
    grid = 20,
    scale = 3,
    things = { },
    current = nil,
    file_path = ""
  }
  bar.update = function(self, dt)
    local mouse_x = love.mouse.getX()
    local mouse_y = love.mouse.getY()
    if mouse_y < self.grid * self.scale then
      local thing = self.things[1 + math.floor(mouse_x / (self.grid * self.scale))]
      if thing then
        thing.hover = true
      end
    else
      if love.mouse.isDown(1) then
        if self.current then
          mouse_x = game.camera:left() + love.mouse.getX() / game.camera.sx
          mouse_y = game.camera:top() + love.mouse.getY() / game.camera.sy
          local x = mouse_x - mouse_x % game.tile_scale
          local y = mouse_y - mouse_y % game.tile_scale
          level:add_tile(x / game.tile_scale, y / game.tile_scale, self.current.name)
        end
      end
      if love.mouse.isDown(2) then
        mouse_x = game.camera:left() + love.mouse.getX() / game.camera.sx
        mouse_y = game.camera:top() + love.mouse.getY() / game.camera.sy
        local x = (mouse_x - mouse_x % game.tile_scale) / game.tile_scale
        local y = (mouse_y - mouse_y % game.tile_scale) / game.tile_scale
        return level:remove_tile(x, y)
      end
    end
  end
  bar.draw = function(self)
    do
      local _with_0 = love.graphics
      _with_0.push()
      local width = _with_0.getWidth() / self.scale
      _with_0.scale(self.scale, self.scale)
      for i = 1, width / self.grid do
        local x = self.x + (i - 1) * self.grid
        local y = 0
        local thing = self.things[i]
        _with_0.setColor(.95, .95, .95)
        if thing then
          if thing.hover then
            _with_0.setColor(.95, .8, .95)
          end
        end
        _with_0.rectangle("fill", x, y, self.grid, self.grid)
        _with_0.setColor(.5, .5, .5)
        _with_0.rectangle("line", x, y, self.grid, self.grid)
        if thing then
          local sprite = thing.sprite
          _with_0.setColor(1, 1, 1)
          if thing == self.current then
            _with_0.setColor(1, 0, 1)
          end
          _with_0.draw(sprite, x, y, 0, self.grid / sprite:getWidth(), self.grid / sprite:getHeight())
          thing.hover = false
        end
      end
      if self.mode == "export" then
        _with_0.setColor(0, .25, 0, .9)
        _with_0.print("[e]xport: " .. tostring(self.file_path), 10, self.grid * 1.85)
      elseif self.mode == "import" then
        _with_0.setColor(0, 0, 0, .9)
        _with_0.print("[i]mport: " .. tostring(self.file_path), 10, self.grid * 1.85)
      end
      _with_0.pop()
      return _with_0
    end
  end
  bar.add = function(self, thing)
    self.things[#self.things + 1] = thing
  end
  bar.click = function(self, mouse_x, mouse_y, button, is_touch)
    if not is_touch and button == 1 then
      if mouse_y < self.grid * self.scale then
        local thing = self.things[1 + math.floor(mouse_x / (self.grid * self.scale))]
        if thing then
          if thing == self.current then
            self.current = nil
          else
            self.current = thing
          end
        end
      end
    end
  end
  bar.press = function(self, key)
    if not (self.mode) then
      if key == "e" then
        self.file_path = ""
        self.mode = "export"
      elseif key == "i" then
        self.file_path = ""
        self.mode = "import"
      end
    end
    if key == "escape" then
      self.mode = nil
    end
    if key == "backspace" and self.mode then
      local byteoffset = utf8.offset(self.file_path, -1)
      if byteoffset then
        self.file_path = string.sub(self.file_path, 1, byteoffset - 1)
      end
    end
    if key == "return" then
      print("return!!", self.mode)
      if self.mode == "export" then
        print("hit export")
        level:export_map("maps/" .. tostring(self.file_path) .. ".png")
      end
      if self.mode == "import" then
        level:load("maps/" .. tostring(self.file_path) .. ".png")
      end
      self.mode = nil
    end
  end
  bar.textinput = function(self, t)
    if self.mode then
      self.file_path = self.file_path .. t
    end
  end
  return bar
end
return {
  make = make
}
