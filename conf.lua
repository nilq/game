local TICK_RATE = 1 / 60
local MAX_FRAME_SKIP = 25
love.run = function()
  if love.load then
    love.load((love.arg.parseGameArguments(arg)), arg)
  end
  if love.timer then
    love.timer.step()
  end
  local lag = 0.0
  return function()
    if love.event then
      love.event.pump()
      for name, a, b, c, d, e, f in love.event.poll() do
        if name == "quit" and (not love.quit or not love.quit()) then
          return a or 0
        end
        love.handlers[name](a, b, c, d, e, f)
      end
    end
    if love.timer then
      lag = math.min(lag + love.timer.step(), TICK_RATE * MAX_FRAME_SKIP)
    end
    while lag >= TICK_RATE do
      if love.update then
        love.update(TICK_RATE)
      end
      lag = lag - TICK_RATE
    end
    do
      local _with_0 = love.graphics
      _with_0.origin()
      _with_0.clear(_with_0.getBackgroundColor())
      if love.draw then
        love.draw()
      end
      _with_0.present()
    end
    if love.timer then
      return love.timer.sleep(0.001)
    end
  end
end
love.conf = function(t)
  t.window.width = 900
  t.window.height = 600
  t.window.title = "VIKING DASH"
  t.window.fullscreen = true
  t.releases = {
    title = "VIKING DASH",
    package = "viking-dash",
    version = "1.0.0",
    author = "nilq",
    description = "play the game please",
    homepage = "net.net",
    identifier = nil,
    excludeFileList = { },
    releaseDirectory = nil
  }
end
