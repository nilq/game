TICK_RATE      = 1 / 60
MAX_FRAME_SKIP = 25

love.run = ->
  love.load (love.arg.parseGameArguments arg), arg if love.load
  love.timer.step!                                 if love.timer

  lag = 0.0

  return ->
    if love.event
      love.event.pump!
      for name, a, b, c, d, e, f in love.event.poll!
        if name == "quit" and (not love.quit or not love.quit!)
          return a or 0

        love.handlers[name] a, b, c, d, e, f

    lag = math.min lag + love.timer.step!, TICK_RATE * MAX_FRAME_SKIP if love.timer

    while lag >= TICK_RATE
      love.update TICK_RATE if love.update
      lag -= TICK_RATE

    with love.graphics
      .origin!
      .clear .getBackgroundColor!
      love.draw! if love.draw

      .present!

    love.timer.sleep 0.001 if love.timer

love.conf = (t) ->
  t.window.width  = 900
  t.window.height = 600
  t.window.title = "niels' pirate game"
  t.window.fullscreen = not true

  t.releases =
    title: "pirate game"
    package: "pirate-game"
    version: "1.0.0"
    author: "nilq"
    description: "play the game please"
    homepage: "net.net"
    identifier: nil
    excludeFileList: {}
    releaseDirectory: nil
