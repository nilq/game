s.sprite = { "position", "size", "sprite" }
s.sprite.draw = (i, pos, size, sprite) ->
  with love.graphics
    .setColor 1, 1, 1
    ox = size.w / sprite.img\getWidth!
    oy = size.h / sprite.img\getHeight!

    .draw sprite.img, pos.x + size.w / 2, pos.y + size.h / 2, 0, ox, oy, sprite.img\getWidth! / 2, sprite.img\getHeight! / 2
