level =
  size: 20
  registry:
    block:  {0, 0, 0}
    player: {1, 1, 0}

  map: {}

  min_x: nil
  min_y: nil

  max_x: nil
  max_y: nil

level.load = (path) =>
  image = love.image.newImageData(path)
  map   = {}

  for x = 0, image\getWidth! - 1
    for y = 0, image\getHeight! - 1
      r, g, b = image\getPixel x, y

      for k, v in pairs @registry
        with math
          e = 0.01
          if (.fuzzy_eq r, v[1], e) and (.fuzzy_eq g, v[2], e) and .fuzzy_eq b, v[3], e
            @spawn k, @size * x, @size * y

level.spawn = (k, x, y) =>
  switch k
    when "block"
      conf =
        position:
          :x, :y
        size:
          w: 24
          h: 24
        color: {0, 0, 0}
        slime:
          visible: false
          dir: {}
          color: { 1, 1, 1 }

      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

    when "player"
      conf =
        position:
          :x, :y
        size:
          w: 16, h: 16
        direction: { 1 }
        physics:
          dx: 0
          dy: 0
          frc_x: 10
          frc_y: 2
          dir:
            x: 0
            y: 0
          speed: 20
          grounded: false
          gravity:
            power: 15
            mod: 1
          jump:
            desire: 0
            force: 5
            doubled: false
          wall:
            dir: 0
            stick: 0
          max_speed: 25
          dash:
            power: 6
            timer: 0
            cooldown: 3
          coyote: 0

        color: { 1, 1, 0 }
        player: {}
        shade: { 1, 1, 0 }
        head:
          body: sprites.player.body
          eyes:
            img: sprites.player.eyes
            x: x
            y: y
          s: 1
          r: 0

      id = e.player conf

      world\add id, x, y, conf.size.w, conf.size.h

level.add_tile = (x, y, id) => -- returns false if it's adding the same
    --TODO: Make the min and max be calculated in @export_map
    --      as adding a tile far away and then removing it
    --      results in an unnecessarily big map, and this could
    --      result in more bugs.
    @min_x = x if @min_x == nil or x < @min_x
    @max_x = x if @max_x == nil or x > @max_x

    @min_y = y if @min_y == nil or y < @min_y
    @max_y = y if @max_y == nil or y > @max_y

    unless @map[x]
      @map[x] = {}
    elseif @map[x][y]
      if id == @map[x][y].id or @map[x][y].id == "player"
        --Place a block ontop of the exact same block or the player spawn point
        --so we shouldn't do anything
        return false

    --create the tile in the game world
    tile = objects[id].make x * game.tile_scale, y * game.tile_scale
    game\spawn tile
    game.world\add tile, tile.x, tile.y, tile.w, tile.h

    @map[x][y] = { :id, ref: tile }

    true

level.remove_tile = (x, y) =>
    --Can't be unless, checks if the block exists
    return if not @map[x] or not @map[x][y]
    -- we do in fact need player
    return if @map[x][y].id == "player"

    level\remove_tile_unchecked x, y

level.remove_tile_unchecked = (x, y) =>
  ref = @map[x][y].ref
  --Make the object remove itself from bump
  ref\remove!

  --Remove from game.objects
  for i, v in ipairs game.objects
    if v == ref
      table.remove game.objects, i
      break

  --Remove from 2d array
  @map[x][y] = nil

level.export_map = (path) =>
  width  = @max_x - @min_x + 1
  height = @max_y - @min_y + 1

  level_img = love.image.newImageData width, height

  for x = 0, @max_x
    continue unless @map[x]

    for y = 0, @max_y
      continue unless @map[x][y]

      color = game.level.registry[@map[x][y].id]

      new_x = x - @min_x
      new_y = y - @min_y

      level_img\setPixel new_x, new_y, color[1], color[2], color[3]

  unless love.filesystem.getInfo "maps"
    love.filesystem.createDirectory "maps"

  level_img\encode "png", path

level