utf8 = require "utf8"

make = ->
  bar = {
    x: 0, y: 0

    grid: 20 -- for grid
    scale: 3 -- for how big things are, bar's its own camera

    things: {}

    current: nil

    file_path: ""
  }

  bar.update = (dt) =>
    mouse_x = love.mouse.getX!
    mouse_y = love.mouse.getY!

    if mouse_y < @grid * @scale
      thing = @things[1 + math.floor mouse_x / (@grid * @scale)]

      if thing
        thing.hover = true
    else
      if love.mouse.isDown 1
        if @current
            mouse_x = game.camera\left! + love.mouse.getX! / game.camera.sx
            mouse_y = game.camera\top!  + love.mouse.getY! / game.camera.sy

            x = mouse_x - mouse_x % game.tile_scale
            y = mouse_y - mouse_y % game.tile_scale

            game.level\add_tile x / game.tile_scale, y / game.tile_scale, @current.name


      if love.mouse.isDown 2
          mouse_x = game.camera\left! + love.mouse.getX! / game.camera.sx
          mouse_y = game.camera\top!  + love.mouse.getY! / game.camera.sy

          x = (mouse_x - mouse_x % game.tile_scale) / game.tile_scale
          y = (mouse_y - mouse_y % game.tile_scale) / game.tile_scale

          game.level\remove_tile x, y

  bar.draw = =>
    with love.graphics
      .push!

      width = .getWidth! / @scale

      .scale @scale, @scale

      for i = 1, width / @grid
        x = @x + (i - 1) * @grid
        y = 0

        thing = @things[i]

        .setColor .95, .95, .95

        if thing
          if thing.hover
            .setColor .95, .8, .95

        .rectangle "fill", x, y, @grid, @grid

        .setColor .5, .5, .5
        .rectangle "line", x, y, @grid, @grid

        if thing
          sprite = thing.sprite

          .setColor 1, 1, 1

          if thing == @current
            .setColor 1, 0, 1

          .draw sprite, x, y, 0, @grid / sprite\getWidth!, @grid / sprite\getHeight!

          thing.hover = false

      if @mode == "exporting"
        .setColor 0, .25, 0, .9
        .print "[e]xport: #{@file_path}", 10, @grid * 1.85
      elseif @mode == "importing"
        .setColor 0, 0, 0, .9
        .print "[i]mport: #{@file_path}", 10, @grid * 1.85

      .pop!


  bar.add = (thing) =>
    @things[#@things + 1] = thing

  bar.click = (mouse_x, mouse_y, button, is_touch) =>
    if not is_touch and button == 1
      if mouse_y < @grid * @scale
        thing = @things[1 + math.floor mouse_x / (@grid * @scale)]

        if thing
          if thing == @current
            @current = nil
          else
            @current = thing

  bar.press = (key) =>
    unless @mode
      if key == "e"
        @file_path = ""
        @mode= "exporting"
      elseif key == "i"
        @file_path = ""
        @mode= "importing"

    if key == "escape"
      @mode = nil

    if key == "backspace" and @mode
      byteoffset = utf8.offset @file_path, -1

      if byteoffset
        @file_path = string.sub @file_path, 1, byteoffset - 1

    if key == "return"
      if @mode == "export"
        game.level\export_map "maps/#{@file_path}.png"
      if @mode == "importing"
        game.level\load "maps/#{@file_path}.png"
      @mode = nil

  bar.textinput = (t) =>
    if @mode
      @file_path ..= t

  bar

{
  :make
}
