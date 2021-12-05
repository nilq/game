e.player = { "position", "size", "physics", "player", "head", "shade", "direction" }

s.player = { "position", "size", "physics", "player", "head", "shade", "direction" }
s.player.update = (i, position, size, physics, player, head, shade, direction) ->

  physics.dir.x = math.sign physics.dx
  physics.dir.x = 0 if math.fuzzy_eq physics.dx, 0, 1.2

  physics.dir.y = math.sign physics.dy

  physics.grounded = game.god

  physics.jump.desire = math.max 0, physics.jump.desire - 1
  physics.wall.stick  = math.max 0, physics.wall.stick - 1
  physics.coyote      = math.max 0, physics.coyote - 1

  physics.dash.timer = math.max 0, physics.dash.timer - game.dt
  head.s = math.max 1.4, head.s - game.dt

  if physics.wall.stick == 0
    physics.wall.dir = 0
    physics.gravity.mod = 1

  unless world.rects[i]
    return

  position.x, position.y, cols = world\move i, position.x + physics.dx, position.y + physics.dy

  physics.dy += physics.gravity.power * physics.gravity.mod * game.dt unless game.god

  for col in *cols
    physics.dx = 0 if col.normal.x != 0
    physics.dy = 0 if col.normal.y != 0

    other = e.get col.other

    if other.slime
      other.slime.visible = true
      abort = false

      blood_color = {
        (172 + math.random -15, 15) / 255,
        (50 + math.random -15, 15)  / 255,
        (50 + math.random -15, 15)  / 255,
      }

      for dir in *other.slime.dir
        if dir.x == col.normal.x and dir.y == col.normal.y
          unless physics.touched_last == dir.color
            dir.color = blood_color
            dir.s = 5
            if dir.extra_h
              dir.extra_h = dir.s

          physics.touched_last = dir.color
          abort = true

      unless abort
        dir =
          color: blood_color
          x: col.normal.x
          y: col.normal.y
          s: 5

        sounds.splat\play!

        table.insert other.slime.dir, dir
        physics.touched_last = dir.color

      physics.wall.dir = -col.normal.x
      physics.wall.stick = 4 if physics.wall.dir != 0

    if other.hurts and other.hurts.gen == GEN and not game.death
      sounds.crunch\play!
      sounds.ouch\play!
      head.eyes.img = sprites.player.eyes_dead

      game.death = true
      game.death_timer = 1
      game.s = 2

      world\update i, position.x, position.y, size.w / 10, size.h / 10
      position.y += 6

      physics.dx = 0
      physics.dy = 0

      if other.sprite.img == sprites.spikes
        other.sprite.img = sprites.bloody
        head.r += math.pi / 10 * math.random -1, 1

      if other.sprite.r
        physics.gravity.power = 0

    if col.normal.y == -1
      sounds.landing\play! unless physics.coyote > 1

      physics.grounded = true
      physics.jump.doubled = false
      physics.coyote = 5

    if physics.wall.dir != 0
      physics.jump.doubled = false

  dist = (math.dist game.camera, position)
  new_cam_x = position.x + physics.dir.x * (math.min 100, math.abs physics.dx * 10)
  new_cam_y = position.y - 80 + physics.dy * 2

  game.camera.x = math.cerp game.camera.x, new_cam_x, game.dt * math.min 10, dist * 2
  game.camera.y = math.cerp game.camera.y, new_cam_y, game.dt * math.min 10, dist * 2

  dist = math.min 5, (math.dist position, head.eyes)

  head.eyes.x = math.lerp head.eyes.x, position.x, game.dt * dist * 10
  head.eyes.y = math.lerp head.eyes.y, position.y - 1, game.dt * dist * 10

  dist = math.min 5, (math.dist position, head.eyes)

  physics.smooth_dir = math.lerp physics.smooth_dir, physics.dir.x, game.dt * 30
  head.helmet.x = position.x + physics.smooth_dir * 3

  py = position.y - size.h / 2 - 6 * 1.5
  target_y = math.lerp head.helmet.y, py, game.dt * dist * 10
  target_y = py if target_y > py

  head.helmet.r = math.lerp head.helmet.r, head.r, game.dt * 40

  head.helmet.y = target_y

  -- all of the funny stuff starts here
  -- ... unless death of course
  if game.death
    head.s = math.lerp head.s, 2, game.dt * 4

    return

  if (physics.wall.stick != 0 or physics.wall.dir != 0) and not grounded
    physics.dx = physics.wall.dir
    physics.gravity.mod = 0.6

  if not game.god and input\pressed "up"
    physics.jump.desire = 5 -- jump inside next 5

  if physics.dash.timer == 0 and input\pressed "dash"
    physics.dx += (physics.dir.x + direction[1]) * physics.dash.power
    physics.dy += physics.dir.y * physics.dash.power

    physics.dash.timer = physics.dash.cooldown

    shack\setShake 7
    head.s = 2

    sounds.dash\play!

  can_jump = physics.grounded or physics.coyote != 0

  should_reset_double = not can_jump
  can_jump = can_jump or (not physics.jump.doubled and physics.wall.dir == 0)

  if can_jump and physics.jump.desire > 0
    sounds.hop\play!

    physics.dy = -physics.jump.force
    physics.dx += physics.dx * (physics.jump.desire / 5)

    physics.jump.desire = 0
    physics.coyote = 0

    if not physics.jump.doubled and should_reset_double
      physics.jump.doubled = true
      head.s = 1.7
      shack\setShake 2

  if physics.wall.dir != 0 and physics.jump.desire > 0
    physics.dy = -physics.jump.force

    physics.dx = (physics.dx) * -1 + -physics.wall.dir * physics.speed / 3

    physics.jump.desire = 0

    physics.wall.dir = 0
    physics.wall.stick = 0

    sounds.kick\play!
    sounds.kick_b\play!

    shack\setShake 0.5

  dx, input_y = input\get "move"
  physics.dx += dx * physics.speed * game.dt

  if physics.wall.stick != 0 and dx != physics.wall.dir
    physics.dx -= physics.wall.dir

  if game.god
    physics.dy += input_y * physics.speed * game.dt

  frcx = physics.frc_x
  frcy = physics.frc_y

  if head.supermario
    head.s += 0.1 * math.cos game.time * 109

  if game.god
    frcx = physics.god_frc
    frcy = frcx

  if physics.grounded and not math.fuzzy_eq physics.dx, 0, 0.2
    sounds.steps\play! unless sounds.steps\isPlaying!

  physics.dx = math.cerp physics.dx, 0, game.dt * frcx
  physics.dy = math.cerp physics.dy, 0, game.dt * frcy

  magic_number = (math.pi / 20)

  head.r = math.cerp head.r, physics.dir.x * magic_number, game.dt * 20

  if physics.dir.x != 0
    direction[1] = physics.dir.x
