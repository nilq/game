with love.graphics
  export gym_mansion = .newImage "res/gymmansion.png"
  export productions = .newImage "res/productions.png"

export clapping = love.audio.newSource "res/sound/clapping.wav", "static"
clapping\setVolume 1.2

clapping\play!

menu =
  timer: 3
  loaded: false

menu.update = (dt) =>
  @timer = math.max 0, @timer - dt

menu.draw = =>
  with love.graphics
    .setColor 1, 1, 1
    .setBackgroundColor 3 - @timer, 3 - @timer, 3 - @timer
    .draw gym_mansion, .getWidth! / 2 - gym_mansion\getWidth! / 2, .getHeight! / 2 - gym_mansion\getHeight! / 2 - productions\getHeight! / 2
    .draw productions, .getWidth! / 2 - productions\getWidth! / 2, .getHeight! / 2 - productions\getHeight! / 2 + productions\getHeight! / 2

menu
