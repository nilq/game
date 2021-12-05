s.cloud = { "position", "speed" }
s.cloud.update = (i, pos, speed) ->
  pos.x += speed[1] * game.dt
