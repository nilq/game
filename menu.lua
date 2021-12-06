do
  local _with_0 = love.graphics
  gym_mansion = _with_0.newImage("res/gymmansion.png")
  productions = _with_0.newImage("res/productions.png")
end
clapping = love.audio.newSource("res/sound/clapping.wav", "static")
clapping:setVolume(1.2)
clapping:play()
local menu = {
  timer = 3,
  loaded = false
}
menu.update = function(self, dt)
  self.timer = math.max(0, self.timer - dt)
end
menu.draw = function(self)
  do
    local _with_0 = love.graphics
    _with_0.setColor(1, 1, 1)
    _with_0.setBackgroundColor(3 - self.timer, 3 - self.timer, 3 - self.timer)
    _with_0.draw(gym_mansion, _with_0.getWidth() / 2 - gym_mansion:getWidth() / 2, _with_0.getHeight() / 2 - gym_mansion:getHeight() / 2 - productions:getHeight() / 2)
    _with_0.draw(productions, _with_0.getWidth() / 2 - productions:getWidth() / 2, _with_0.getHeight() / 2 - productions:getHeight() / 2 + productions:getHeight() / 2)
    return _with_0
  end
end
return menu
