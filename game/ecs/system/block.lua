s.block = {
  "position",
  "size",
  "color",
  "slime"
}
s.block.draw = function(i, position, size, color, slime)
  do
    local _with_0 = love.graphics
    _with_0.setColor(color)
    _with_0.rectangle("fill", position.x, position.y, size.w, size.h)
    if slime.visible then
      local _list_0 = slime.dir
      for _index_0 = 1, #_list_0 do
        local dir = _list_0[_index_0]
        _with_0.setColor(dir.color)
        local x, y = position.x, position.y
        local w, h = size.w, 4
        if dir.x ~= 0 then
          h = size.h
          w = 4
          if dir.x == 1 then
            x = position.x + size.w - 4
          end
        end
        if dir.y > 0 then
          y = position.y + size.h - 4
        end
        _with_0.rectangle("fill", x, y, w, h, slime.angle)
        _with_0.rectangle("fill", x, y, w, h, slime.angle)
      end
    end
    return _with_0
  end
end
