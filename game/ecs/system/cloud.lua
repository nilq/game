s.cloud = {
  "position",
  "speed"
}
s.cloud.update = function(i, pos, speed)
  pos.x = pos.x + (speed[1] * game.dt)
end
