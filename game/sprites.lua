love.graphics.setDefaultFilter("nearest", "nearest")
local img
img = function(x)
  return love.graphics.newImage("res/" .. x .. ".png")
end
sprites = {
  player = {
    eyes = img("player/eyes"),
    body = img("player/body")
  }
}
