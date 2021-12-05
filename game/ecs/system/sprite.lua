s.sprite = {
  "position",
  "size",
  "sprite"
}
s.sprite.draw = function(i, pos, size, sprite)
  do
    local _with_0 = love.graphics
    _with_0.setColor(1, 1, 1)
    local ox = size.w / sprite.img:getWidth()
    local oy = size.h / sprite.img:getHeight()
    _with_0.draw(sprite.img, pos.x + size.w / 2, pos.y + size.h / 2, sprite.r or 0, ox, oy, sprite.img:getWidth() / 2, sprite.img:getHeight() / 2)
    return _with_0
  end
end
