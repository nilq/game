level =
  size: 24
  registry:
    block:  {0, 0, 0}
    player: {1, 243 / 255, 0}
    spike: {1, 0, 0}
    spike_left: {172 / 255, 50 / 255, 50 / 255}
    spike_right: {217 / 255, 87 / 255, 99 / 255}

    house: {0, 0, 1}
    dont: {102 / 255, 57 / 255, 49 / 255}
    dirt: { 138 / 255, 111 / 255, 48 / 255 }

    grass: { 152 / 255, 229 / 255, 80 / 255 }
    nothing_dirt: { 132 / 255, 126 / 255, 135 / 255 }

    cloud: { 155 / 255, 173 / 255, 183 / 255 }

    snow: { 91 / 255, 110 / 255, 225 / 255 }
    bush: { 215 / 255, 123 / 255, 186 / 255 }

    door: {0, 1, 0}

  map: {}

  min_x: nil
  min_y: nil

  max_x: nil
  max_y: nil

  player_coords:
    x: 0
    y: 0

level.load = (path) =>
  image = love.image.newImageData(path)
  map   = {}

  for x = 0, image\getWidth! - 1
    map[x] = {}
    for y = 0, image\getHeight! - 1
      r, g, b = image\getPixel x, y

      for k, v in pairs @registry
        with math
          e = 0.01
          if (.fuzzy_eq r, v[1], e) and (.fuzzy_eq g, v[2], e) and .fuzzy_eq b, v[3], e
            map[x][y] = @spawn k, @size * x, @size * y

  return 0

level.spawn = (k, x, y) =>
  grass_conf =
    position:
      :x, :y
    size:
      w: 24
      h: 24
    sprite:
      img: sprites.grass_full
      r: 0
    slime:
      visible: false
      dir: {}
      color: { 1, 1, 1 }

  switch k
    when "block"
      conf = grass_conf
      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "door"
      bruh =
        position:
          :x
          y: y - 8 * 1.5
        size:
          w: sprites.door\getWidth! * 1.5
          h: sprites.door\getHeight! * 1.5
        sprite:
          img: sprites.door
        door:
          gen: GEN

      id = e.door bruh
      world\add id, bruh.position.x, bruh.position.y, bruh.size.w, bruh.size.h

      return id

    when "block"
      conf = grass_conf
      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "grass"
      conf = grass_conf
      conf.sprite.img = sprites.grass_full
      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "snow"
      conf = grass_conf
      conf.sprite.img = sprites.snow
      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "dirt"
      conf = grass_conf
      conf.sprite.img = sprites.dirt
      id = e.block conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "nothing_dirt"
      conf = grass_conf
      conf.sprite.img = sprites.dirt
      id = e.block conf

      return id

    when "cloud"

      for i = 0, math.random 3, 7
        spr = sprites.clouds[math.random 1, #sprites.clouds]
        conf =
          position:
            x: x + math.random -36, 36
            y: y + math.random -16, 16
          size:
            w: spr\getWidth! * 1.5
            h: spr\getHeight! * 1.5
          sprite:
            img: spr
          speed: {3}

        id = e.cloud conf

      return id

    when "dont"
      id = e.nothing {}
      world\add id, x, y, 24, 24
      return id

    when "house"
      conf =
        position:
          :x
          y: y - 75
        size:
          w: sprites.house\getWidth! * 1.5
          h: sprites.house\getHeight! * 1.5
        sprite:
          img: sprites.house

      id = e.house conf

      return id

    when "bush"
      conf =
        position:
          :x
          y: y + 6
        size:
          w: sprites.bush\getWidth!
          h: sprites.bush\getHeight!
        sprite:
          img: sprites.bush

      id = e.house conf

      return id


    when "spike"
      conf =
        position:
          :x, :y
        size:
          w: 24
          h: 24
        sprite:
          img: sprites.spikes
        hurts:
          gen: GEN

      id = e.spike conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "spike_left"
      conf =
        position:
          :x, :y
        size:
          w: 24
          h: 24
        sprite:
          img: sprites.spikes
          r: 0
        hurts:
          gen: GEN


      conf.sprite.r = -math.pi / 2
      id = e.spike conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id

    when "spike_right"
      conf =
        position:
          :x, :y
        size:
          w: 24
          h: 24
        sprite:
          img: sprites.spikes
          r: 0
        hurts:
          gen: GEN


      conf.sprite.r = math.pi / 2
      id = e.spike conf
      world\add id, x, y, conf.size.w, conf.size.h

      return id


    when "player"
      @player_coords =
        :x, :y

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

          god_frc: 15

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
          smooth_dir: 0
        color: { 1, 1, 0 }
        player: {}
        shade: { 1, 1, 0 }
        head:
          body: sprites.player.body
          eyes:
            img: sprites.player.eyes
            x: x
            y: y
          helmet:
            img: sprites.player.helmet
            :x
            y: y - 8 * 1.5
            r: 0
          trail:
            on: false
            a: 1
            trail:
              trail\new
                type: "point"
                content:
                  type: "image"
                  source: sprites.player.body
                duration: 0.2
                amount: 100
                fade: "shrink"
          s: 1
          r: 0

      conf.head.trail.trail\setPosition x, y
      id = e.player conf

      world\add id, x, y, conf.size.w, conf.size.h

      return id

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
    tile = @spawn id, x * level.size, y * level.size

    print "Spawned: " .. id .. " at (" .. (tostring x) .. ", " .. (tostring y) .. ")"

    @map[x][y] = { :id, ref: tile }

    true

level.remove_tile = (x, y) =>
    --Can't be unless, checks if the block exists
    return if not @map[x] or not @map[x][y]
    -- we do in fact need player
    return if @map[x][y].id == "player"

    level\remove_tile_unchecked x, y

level.remove_tile_unchecked = (x, y) =>
  i = @map[x][y].ref

  e.delete i
  world\remove i
  --Remove from 2d array
  @map[x][y] = nil

level.export_map = (path) =>
  width  = @max_x - @min_x + 1
  height = @max_y - @min_y + 1

  level_img = love.image.newImageData width, height

  for x = 0, width - 1
    for y = 0, height - 1
      level_img\setPixel x, y, 1, 1, 1

  xi = 0
  yi = 0

  for x = @min_x, @max_x
    xi += 1
    yi = 0
    continue unless @map[x]

    for y = @min_y, @max_y
      yi += 1
      continue unless @map[x][y]

      color = level.registry[@map[x][y].id]

      new_x = xi - 1
      new_y = yi - 1

      level_img\setPixel new_x, new_y, color[1], color[2], color[3]

  level_img\setPixel @player_coords.x, @player_coords.y, level.registry["player"]

  unless love.filesystem.getInfo "maps"
    love.filesystem.createDirectory "maps"

  print path
  level_img\encode "png", path

level
