love.graphics.setDefaultFilter("nearest", "nearest")
local img
img = function(x)
  return love.graphics.newImage("res/" .. x .. ".png")
end
sprites = {
  player = {
    eyes = img("player/eyes"),
    eyes_dead = img("player/eyes_dead"),
    body = img("player/body")
  },
  spikes = img("things/spikies"),
  bloody = img("things/bloody_spikes"),
  unworthy = img("unworthy")
}
