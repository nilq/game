s.input = {
  "input"
}
s.input.update = function(i, input)
  do
    local _with_0 = love.keyboard
    local _
    input.x, _ = controls:get("move")
    input.up = controls:pressed("up")
    input.down = controls
    return _with_0
  end
end
s.input_reset = {
  "input"
}
s.input_reset.update = function(i, input)
  input.up = false
end
