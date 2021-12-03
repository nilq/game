love.graphics.setDefaultFilter "nearest", "nearest"
img = (x) -> love.graphics.newImage "res/" .. x .. ".png"

export sprites

sprites =
  player:
    eyes: img "player/eyes"
    body: img "player/body"
