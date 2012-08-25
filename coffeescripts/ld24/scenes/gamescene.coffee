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
    for i in [0...60]
      mob = new LD24.Mobs.Mote @game, this, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed

      @mobs.push mob


  tick: ->
    # zoom transition
    @zoom += (@toZoom - @zoom) / 10

    # scroll transition
    @scrollX += (@toScrollX - @scrollX) / 10
    @scrollY += (@toScrollY - @scrollY) / 10

    # boundary scrolling
    if @player.y * @zoom < @toScrollY + 50
      @toScrollY = @player.y * @zoom - 50
    else if @player.y * @zoom > @toScrollY + @screen.height - 50
      @toScrollY = @player.y * @zoom - @screen.height + 50

    if @player.x * @zoom < @toScrollX + 50
      @toScrollX = @player.x * @zoom - 50
    else if @player.x * @zoom > @toScrollX + @screen.width - 50
      @toScrollX = @player.x * @zoom - @screen.width + 50

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