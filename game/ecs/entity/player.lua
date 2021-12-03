e.player = {
  "position",
  "size",
  "physics",
  "player",
  "head",
  "shade",
  "direction"
}
s.player = {
  "position",
  "size",
  "physics",
  "player",
  "head",
  "shade",
  "direction"
}
s.player.update = function(i, position, size, physics, player, head, shade, direction)
  physics.dir.x = math.sign(physics.dx)
  if math.fuzzy_eq(physics.dx, 0, 1.2) then
    physics.dir.x = 0
  end
  physics.dir.y = math.sign(physics.dy)
  physics.grounded = false
  physics.jump.desire = math.max(0, physics.jump.desire - 1)
  physics.wall.stick = math.max(0, physics.wall.stick - 1)
  physics.coyote = math.max(0, physics.coyote - 1)
  physics.dash.timer = math.max(0, physics.dash.timer - game.dt)
  head.s = math.max(1.4, head.s - game.dt)
  if physics.wall.stick == 0 then
    physics.wall.dir = 0
    physics.gravity.mod = 1
  end
  local cols
  position.x, position.y, cols = world:move(i, position.x + physics.dx, position.y + physics.dy)
  physics.dy = physics.dy + (physics.gravity.power * physics.gravity.mod * game.dt)
  for _index_0 = 1, #cols do
    local col = cols[_index_0]
    if col.normal.x ~= 0 then
      physics.dx = 0
    end
    if col.normal.y ~= 0 then
      physics.dy = 0
    end
    local other = e.get(col.other)
    if other.slime then
      other.slime.visible = true
      local abort = false
      local _list_0 = other.slime.dir
      for _index_1 = 1, #_list_0 do
        local dir = _list_0[_index_1]
        if dir == col.normal then
          dir.color[1] = shade[1]
          dir.color[2] = shade[2]
          dir.color[3] = shade[3]
          abort = true
        end
      end
      if not (abort) then
        local dir = {
          color = {
            shade[1],
            shade[2],
            shade[3]
          },
          x = col.normal.x,
          y = col.normal.y
        }
        table.insert(other.slime.dir, dir)
      end
    end
    if col.normal.y == -1 then
      physics.grounded = true
      physics.jump.doubled = false
      physics.coyote = 5
    end
    physics.wall.dir = -col.normal.x
    if physics.wall.dir ~= 0 then
      physics.wall.stick = 4
    end
    if physics.wall.dir ~= 0 then
      physics.jump.doubled = false
    end
  end
  if (physics.wall.stick ~= 0 or physics.wall.dir ~= 0) and not grounded then
    physics.dx = physics.wall.dir
    physics.gravity.mod = 0.6
  end
  if input:pressed("up") then
    physics.jump.desire = 5
  end
  if physics.dash.timer == 0 and input:pressed("dash") then
    physics.dx = physics.dx + ((physics.dir.x + direction[1]) * physics.dash.power)
    physics.dy = physics.dy + (physics.dir.y * physics.dash.power)
    physics.dash.timer = physics.dash.cooldown
    shack:setShake(7)
    head.s = 2
  end
  local can_jump = physics.grounded or physics.coyote ~= 0
  local should_reset_double = not can_jump
  can_jump = can_jump or (not physics.jump.doubled and physics.wall.dir == 0)
  if can_jump and physics.jump.desire > 0 then
    physics.dy = -physics.jump.force
    physics.dx = physics.dx + (physics.dx * (physics.jump.desire / 5))
    physics.jump.desire = 0
    physics.coyote = 0
    if not physics.jump.doubled and should_reset_double then
      physics.jump.doubled = true
      head.s = 1.7
      shack:setShake(2)
    end
  end
  if physics.wall.dir ~= 0 and physics.jump.desire > 0 then
    physics.dy = -physics.jump.force
    physics.dx = (physics.dx) * -1 + -physics.wall.dir * physics.speed / 3
    physics.jump.desire = 0
    physics.wall.dir = 0
    physics.wall.stick = 0
  end
  local dx, _ = input:get("move")
  physics.dx = physics.dx + (dx * physics.speed * game.dt)
  local dist = (math.dist(game.camera, position))
  local new_cam_x = position.x + physics.dir.x * (math.min(100, math.abs(physics.dx * 10)))
  local new_cam_y = position.y
  game.camera.x = math.cerp(game.camera.x, new_cam_x, game.dt * math.min(10, dist * 2))
  game.camera.y = math.cerp(game.camera.y, new_cam_y, game.dt * math.min(10, dist * 2))
  dist = math.min(5, (math.dist(position, head.eyes)))
  head.eyes.x = math.lerp(head.eyes.x, position.x, game.dt * dist * 10)
  head.eyes.y = math.lerp(head.eyes.y, position.y - 1, game.dt * dist * 10)
  physics.dx = math.cerp(physics.dx, 0, game.dt * physics.frc_x)
  physics.dy = math.cerp(physics.dy, 0, game.dt * physics.frc_y)
  local magic_number = (math.pi / 20)
  head.r = math.cerp(head.r, physics.dir.x * magic_number, game.dt * 20)
  if physics.dir.x ~= 0 then
    direction[1] = physics.dir.x
  end
end
