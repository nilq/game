make = ->
  grid = {
    tile_scale: 20
  }

  grid.draw = =>
    with game.camera
      love.graphics.setLineWidth(1 / .sx)
      love.graphics.setColor(0, 0, 0)

      --Vertical lines
      offset = \left! % game.tile_scale

      for i = 0, \width! / game.tile_scale do
        --Top point
        --Each line is slitghly more to the right than previous one
        x1, y1 = \left! - offset + i * game.tile_scale, \top!
        --Bottom point
        x2, y2 = x1, \bot!
        --Line from top to bottom
        love.graphics.line x1, y1, x2, y2

      --Horizontal lines
      offset = \top! % game.tile_scale

      for i = 0, \height! / game.tile_scale do
        --Left point     each line is slitghly lower than the previous one
        x1, y1 = \left!, \top! - offset + i * game.tile_scale
        --Right point
        x2, y2 = \right!, y1
        --Draw line from left to right
        love.graphics.line x1, y1, x2, y2

  grid.draw_highlight = =>
    if game.bar.current
      with love.graphics
        .setColor 1, 1, 1

        mouse_x = game.camera\left! + love.mouse.getX! / game.camera.sx
        mouse_y = game.camera\top!  + love.mouse.getY! / game.camera.sy

        .draw game.bar.current.sprite, mouse_x - mouse_x % @tile_scale, mouse_y - mouse_y % @tile_scale


  grid

{
  :make
}
