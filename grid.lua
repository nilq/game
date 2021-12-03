local make
make = function()
  local grid = {
    tile_scale = 24
  }
  grid.draw = function(self)
    do
      local _with_0 = game.camera
      love.graphics.setLineWidth(1 / _with_0.sx)
      love.graphics.setColor(0, 0, 0)
      local offset = _with_0:left() % game.tile_scale
      for i = 0, _with_0:width() / game.tile_scale do
        local x1, y1 = _with_0:left() - offset + i * game.tile_scale, _with_0:top()
        local x2, y2 = x1, _with_0:bot()
        love.graphics.line(x1, y1, x2, y2)
      end
      offset = _with_0:top() % game.tile_scale
      for i = 0, _with_0:height() / game.tile_scale do
        local x1, y1 = _with_0:left(), _with_0:top() - offset + i * game.tile_scale
        local x2, y2 = _with_0:right(), y1
        love.graphics.line(x1, y1, x2, y2)
      end
      return _with_0
    end
  end
  grid.draw_highlight = function(self)
    if game.bar.current then
      do
        local _with_0 = love.graphics
        _with_0.setColor(1, 1, 1)
        local mouse_x = game.camera:left() + love.mouse.getX() / game.camera.sx
        local mouse_y = game.camera:top() + love.mouse.getY() / game.camera.sy
        _with_0.draw(game.bar.current.sprite, mouse_x - mouse_x % self.tile_scale, mouse_y - mouse_y % self.tile_scale)
        return _with_0
      end
    end
  end
  return grid
end
return {
  make = make
}
