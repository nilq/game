draw = (sprite, size, dir, x, y, s, r) ->
  with love.graphics
    ox = s * size.w / sprite\getWidth! * dir[1]
    oy = s * size.h / sprite\getHeight!
    .draw sprite, x + size.w / 2, y + size.h / 2, r, ox, oy, sprite\getWidth! / 2, sprite\getHeight! / 2

s.head = { "position", "direction", "size", "head", "shade" }
s.head.draw = (i, pos, dir, size, head, shade) ->
  if head.trail.on
    love.graphics.setColor 1, 1, 1, head.trail.a
    head.trail.trail\draw!

  love.graphics.setColor { 238 / 255, 195 / 255, 154 / 255  }
  draw head.body, size, dir, pos.x, pos.y, 1, head.r

  love.graphics.setColor 1, 1, 1

  draw head.helmet.img, size, dir, head.helmet.x, head.helmet.y, 1.5, head.helmet.r
  draw head.eyes.img, size, dir, head.eyes.x + dir[1] * 2, head.eyes.y, head.s, head.r
