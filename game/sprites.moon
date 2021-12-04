love.graphics.setDefaultFilter "nearest", "nearest"
img = (x) -> love.graphics.newImage "res/" .. x .. ".png"

export sprites

sprites =
  player:
    eyes: img "player/eyes"
    eyes_dead: img "player/eyes_dead"
    body: img "player/body"
  spikes: img "things/spikies"
  bloody: img "things/bloody_spikes"
  unworthy: img "unworthy"
