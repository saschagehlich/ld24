window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.GameScene = class GameScene
  constructor: (@game, @screen) ->
    @player = new LD24.Mobs.Player @game, this, @screen
    @player.x = @screen.width / 2
    @player.y = @screen.height / 2

    @player.scale = 0.04
    @player.toScale = @player.scale

    @zoom = 5
    @toZoom = @zoom
    @scrollX = @screen.width / 2 * @zoom - @screen.width / 2
    @toScrollX = @scrollX
    @scrollY = @screen.height / 2 * @zoom - @screen.height / 2
    @toScrollY = @scrollY

    @mobs = [@player]
  
    @generateMobs()

    $(document).keydown (e) =>
      switch e.keyCode
        when 189
          @toZoom = Math.max 1, @toZoom - 1
          @toScrollX = @screen.width / 2 * @toZoom - @screen.width / 2
          @toScrollY = @screen.height / 2 * @toZoom - @screen.height / 2
        when 187
          @toZoom = Math.min 5, @toZoom + 1
          @toScrollX = @screen.width / 2 * @toZoom - @screen.width / 2
          @toScrollY = @screen.height / 2 * @toZoom - @screen.height / 2

  generateMobs: ->
    # Normal mobs
    for i in [0...60]
      mob = new LD24.Mobs.Mote @game, this, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @mobs.push mob

    # Power ups
    for i in [0...2]
      mob = new LD24.Mobs.PowerUp @game, this, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @mobs.push mob

  tick: ->
    # zoom transition
    @zoom += (@toZoom - @zoom) / 10

    # scroll transition
    @scrollX += (@toScrollX - @scrollX) / 10
    @scrollY += (@toScrollY - @scrollY) / 10

    # boundary scrolling
    if @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale < @toScrollY + 50
      @toScrollY = @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale - 50
    else if @player.y * @zoom + @player.spriteH / 2 * @zoom * @player.scale > @toScrollY + @screen.height - 50
      @toScrollY = @player.y * @zoom - @screen.height + @player.spriteH / 2 * @zoom * @player.scale + 50

    if @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale < @toScrollX + 50
      @toScrollX = @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale - 50
    else if @player.x * @zoom + @player.spriteW / 2 * @zoom * @player.scale > @toScrollX + @screen.width - 50
      @toScrollX = @player.x * @zoom - @screen.width + @player.spriteW / 2 * @zoom * @player.scale + 50

    @toScrollX = Math.min @toScrollX, @screen.width * @zoom - @screen.width
    @toScrollX = Math.max @toScrollX, 0

    @toScrollY = Math.min @toScrollY, @screen.height * @zoom - @screen.height
    @toScrollY = Math.max @toScrollY, 0

    # tick / absorb / remove mobs
    for mob in @mobs
      if mob.removed
        @mobs = _.without @mobs, mob
      else
        mob.tick()

      for otherMob in @mobs
        if mob.intersects(otherMob) and mob.scale > otherMob.scale and otherMob isnt mob and not otherMob.absorbed
          mob.absorb otherMob

  render: ->
    @renderBackground()

    for mob in @mobs
      # conditional rendering
      if mob.x * @zoom - (mob.spriteW * mob.scale * @zoom) / 2 < @scrollX + @screen.width and
        mob.x * @zoom + (mob.spriteW * mob.scale * @zoom) / 2 > @scrollX and
        mob.y * @zoom + (mob.spriteH * mob.scale * @zoom) / 2 > @scrollY and
        mob.y * @zoom - (mob.spriteH * mob.scale * @zoom) / 2 < @scrollY + @screen.height
          mob.render()

  renderBackground: ->
    @screen.save()

    @screen.context.fillStyle = 'rgb(10,14,30)'
    @screen.context.fillRect 0, 0, @screen.width, @screen.height

    @screen.restore()