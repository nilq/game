s.input = { "input" }
s.input.update = (i, input) ->
  with love.keyboard
    input.x, _  = controls\get "move"
    input.up    = controls\pressed "up"
    input.down  = controls

s.input_reset = { "input" }
s.input_reset.update = (i, input) ->
  input.up = false
