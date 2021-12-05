local draw
draw = function(sprite, size, dir, x, y, s, r)
  do
    local _with_0 = love.graphics
    local ox = s * size.w / sprite:getWidth() * dir[1]
    local oy = s * size.h / sprite:getHeight()
    _with_0.draw(sprite, x + size.w / 2, y + size.h / 2, r, ox, oy, sprite:getWidth() / 2, sprite:getHeight() / 2)
    return _with_0
  end
end
s.head = {
  "position",
  "direction",
  "size",
  "head",
  "shade"
}
s.head.draw = function(i, pos, dir, size, head, shade)
  love.graphics.setColor({
    238 / 255,
    195 / 255,
    154 / 255
  })
  draw(head.body, size, dir, pos.x, pos.y, 1, head.r)
  love.graphics.setColor(1, 1, 1)
  draw(head.helmet.img, size, dir, head.helmet.x, head.helmet.y, 1.5, head.helmet.r)
  return draw(head.eyes.img, size, dir, head.eyes.x + dir[1] * 2, head.eyes.y, head.s, head.r)
end
