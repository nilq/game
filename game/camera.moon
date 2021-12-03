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

  --The width of the camera in in-game distance
  camera.width = =>
    love.graphics.getWidth! / @sx

  --The height of the camera in in-game distance
  camera.height = =>
    love.graphics.getHeight! / @sy

  --Position of the left border of the camera in the gameworld
  camera.left = =>
    @x / @sx - @width!/2

  --Position of the right border of the camera in the gameworld
  camera.right = =>
    @x / @sx + @width!/2

  camera.top = =>
    @y / @sy - @height!/2

  camera.bot = =>
    @y / @sy + @height!/2

  camera

make
