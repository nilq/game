make = (x, y, sx, sy, r) ->
  camera =
    :x, :y
    :sx, :sy
    :r

  camera.set = =>
    with love.graphics
      .push!
      .translate .getWidth! / 2 - @x * @sx, .getHeight! / 2 - @y * @sy
      .scale @sx, @sy
      .rotate @r

  camera.unset = =>
    love.graphics.pop!

  camera.move = (dx, dy) =>
    @x += dx
    @y += dy

  camera

make
