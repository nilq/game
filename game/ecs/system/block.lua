local blood_size = 6
s.block = {
  "position",
  "size",
  "slime"
}
s.block.draw = function(i, position, size, slime)
  do
    local _with_0 = love.graphics
    if slime.visible then
      local _list_0 = slime.dir
      for _index_0 = 1, #_list_0 do
        local dir = _list_0[_index_0]
        _with_0.setColor(dir.color)
        blood_size = dir.s or blood_size
        local x, y = position.x, position.y
        local w, h = size.w, blood_size
        if dir.x ~= 0 then
          h = size.h + (dir.extra_h or 0)
          w = blood_size
          if dir.x == 1 then
            x = position.x + size.w - blood_size
          end
        end
        if dir.y > 0 then
          y = position.y + size.h - blood_size
        end
        _with_0.rectangle("fill", x, y, w, h, slime.angle)
        _with_0.rectangle("fill", x, y, w, h, slime.angle)
      end
    end
    return _with_0
  end
end
