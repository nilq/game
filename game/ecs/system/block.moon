blood_size = 6

s.block = { "position", "size", "slime" }
s.block.draw = (i, position, size, slime) ->
  with love.graphics
    if slime.visible
      for dir in *slime.dir
        .setColor dir.color

        blood_size = dir.s or blood_size

        x, y = position.x, position.y
        w, h = size.w, blood_size

        if dir.x != 0
          h = size.h + (dir.extra_h or 0)
          w = blood_size

          if dir.x == 1
            x = position.x + size.w - blood_size

        if dir.y > 0
          y = position.y + size.h - blood_size

        .rectangle "fill", x, y, w, h, slime.angle
        .rectangle "fill", x, y, w, h, slime.angle
