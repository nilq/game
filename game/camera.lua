local make
make = function(x, y, sx, sy, r)
  local camera = {
    x = x,
    y = y,
    sx = sx,
    sy = sy,
    r = r
  }
  camera.set = function(self)
    do
      local _with_0 = love.graphics
      _with_0.push()
      _with_0.translate(_with_0.getWidth() / 2 - self.x * self.sx, _with_0.getHeight() / 2 - self.y * self.sy)
      _with_0.scale(self.sx, self.sy)
      _with_0.rotate(self.r)
      return _with_0
    end
  end
  camera.unset = function(self)
    return love.graphics.pop()
  end
  camera.move = function(self, dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
  end
  camera.width = function(self)
    return love.graphics.getWidth() / self.sx
  end
  camera.height = function(self)
    return love.graphics.getHeight() / self.sy
  end
  camera.left = function(self)
    return self.x - self:width() / 2
  end
  camera.right = function(self)
    return self.x + self:width() / 2
  end
  camera.top = function(self)
    return self.y - self:height() / 2
  end
  camera.bot = function(self)
    return self.y + self:height() / 2
  end
  return camera
end
return make
