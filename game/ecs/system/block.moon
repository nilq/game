s.block = { "position", "size", "color", "slime" }
s.block.draw = (i, position, size, color, slime) ->
  with love.graphics
    .setColor color
    .rectangle "fill", position.x, position.y, size.w, size.h

    if slime.visible
      for dir in *slime.dir
        .setColor dir.color

        x, y = position.x, position.y
        w, h = size.w, 4

        if dir.x != 0
          h = size.h
          w = 4

          if dir.x == 1
            x = position.x + size.w - 4

        if dir.y > 0
          y = position.y + size.h - 4

        .rectangle "fill", x, y, w, h, slime.angle
