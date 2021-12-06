love.graphics.setDefaultFilter("nearest", "nearest")
local img
img = function(x)
  return love.graphics.newImage("res/" .. x .. ".png")
end
sprites = {
  player = {
    eyes = img("player/eyes"),
    eyes_dead = img("player/eyes_dead"),
    body = img("player/body"),
    helmet = img("player/helmet")
  },
  spikes = img("things/spikies"),
  bloody = img("things/bloody_spikes"),
  unworthy = img("unworthy"),
  house = img("things/house"),
  grass = img("things/grass"),
  dirt = img("things/dirt"),
  grass_full = img("things/grass_full"),
  bush = img("things/bush"),
  snow = img("things/snow"),
  door = img("things/doort"),
  sun = img("sun"),
  win = love.graphics.newImage("res/youwin.jpg"),
  clouds = {
    img("cloud1"),
    img("cloud2"),
    img("cloud3")
  }
}
