window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.GameScene = class GameScene extends EventEmitter
  constructor: (@game, @screen) ->
    @running = false

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
    @particles = []

    @levelNum = 4
    @level = new LD24.Levels['Level' + @levelNum] @game, this, @screen
    @level.on 'win', =>
      $('.level-progress').fadeOut 'slow'
      $('.level-complete').text('Level complete').fadeIn 'slow'

      after 2000, =>
        @unloadLevel()

    @level.on 'lost', (reason='You have been absorbed by a bigger particle.') =>
      $('.level-progress').fadeOut 'slow'
      $('.level-complete').text('You lost').fadeIn 'slow'
      $('.level-complete-detail').text(reason).fadeIn 'slow'

    @generateParticles()
    @loadLevel()

    $(document).keydown (e) =>
      switch e.keyCode
        when 189
          @zoomOut()
        when 187
          @zoomIn()

  unloadLevel: ->
    @level.terminate()

    $('.level-complete').fadeOut 'slow'
    $('canvas').fadeOut 'slow', =>
      @running = false

      @levelNum++
      @level = new LD24.Levels['Level' + @levelNum] @game, this, @screen
      @loadLevel()

  loadLevel: ->
    $('.level-complete').text @level.name
    $('.level-complete-detail').text @level.subname

    $('.level-complete').fadeIn 'slow'
    $('.level-complete-detail').fadeIn 'slow', =>
      after 2000, =>
        $('.level-complete').fadeOut 'slow'
        $('.level-complete-detail').fadeOut 'slow', =>

          @running = true

          $('canvas').fadeIn 'slow'
          $('.level-progress').fadeIn 'slow'

  zoomOut: ->
    @toZoom = Math.max 1, @toZoom - 1

    # linear zoomOut
    @toScrollX = @scrollX / @zoom * @toZoom
    @toScrollY = @scrollY / @zoom * @toZoom
    

  zoomIn: ->
    @toZoom = Math.min 5, @toZoom + 1

    # linear zoomIn
    @toScrollX = @scrollX / @zoom * @toZoom
    @toScrollY = @scrollY / @zoom * @toZoom

  generateParticles: ->
    for i in [0...500]
      particle = new LD24.Particle @game, this, @screen
      particle.x = Math.random() * @screen.width
      particle.y = Math.random() * @screen.height

      # For parallax effect
      particle.scrollX = @scrollX
      particle.scrollY = @scrollY

      particle.speedX = particle.toSpeedX = Math.random() * 0.05
      if Math.round(Math.random()) is 0
        particle.speedX *= -1
      particle.speedY = particle.toSpeedY = Math.random() * 0.05
      if Math.round(Math.random()) is 0
        particle.speedY *= -1

      @particles.push particle

  tick: ->
    unless @running
      return

    # zoom transition
    @zoom += (@toZoom - @zoom) / 10

    # scroll transition
    @scrollX += (@toScrollX - @scrollX) / 10
    @scrollY += (@toScrollY - @scrollY) / 10

    for particle in @particles
      particle.tick()

    # boundary scrolling
    if @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale < @scrollY + 50
      @toScrollY = @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale - 50
    else if @player.y * @zoom + @player.spriteH / 2 * @zoom * @player.scale > @scrollY + @screen.height - 50
      @toScrollY = @player.y * @zoom - @screen.height + @player.spriteH / 2 * @zoom * @player.scale + 50

    if @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale < @scrollX + 50
      @toScrollX = @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale - 50
    else if @player.x * @zoom + @player.spriteW / 2 * @zoom * @player.scale > @scrollX + @screen.width - 50
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
        if mob.intersects(otherMob) and otherMob isnt mob and not otherMob.absorbed
          mob.absorb otherMob

  render: ->
    unless @running
      return

    @renderBackground()

    for particle in @particles
      if particle.x * @zoom - @scrollX < @screen.width and
        particle.x * @zoom - @scrollX + particle.spriteW * particle.scale * @zoom > 0 and
        particle.y * @zoom - @scrollY + particle.spriteH * particle.scale * @zoom > 0 and
        particle.y * @zoom - @scrollY < @screen.height
          particle.render()

    for mob in @mobs
      # conditional rendering
      if mob.x * @zoom - (mob.spriteW * mob.scale * @zoom) / 2 < @scrollX + @screen.width and
        mob.x * @zoom + (mob.spriteW * mob.scale * @zoom) / 2 > @scrollX and
        mob.y * @zoom + (mob.spriteH * mob.scale * @zoom) / 2 > @scrollY and
        mob.y * @zoom - (mob.spriteH * mob.scale * @zoom) / 2 < @scrollY + @screen.height
          mob.render()

      # is there a special mob around? draw an arrow for him
      if mob instanceof LD24.Mobs.Bad or mob instanceof LD24.Mobs.PowerUp
        distX = Math.abs(mob.x - (@scrollX + @screen.width / 2) / @zoom)
        distY = Math.abs(mob.y - (@scrollY + @screen.height / 2) / @zoom)

        distanceMin = (distX < @screen.width / 2 / @zoom + mob.spriteW * mob.scale and distY < @screen.height / 2 / @zoom + mob.spriteW * mob.scale)
        distanceMax = distX < @screen.width / @zoom + mob.spriteW * mob.scale and distY < @screen.height / @zoom + mob.spriteW * mob.scale
        if not distanceMin and distanceMax
          # draw arrow into this direction
          arrowX = (mob.x * @zoom) - @scrollX
          arrowX = Math.max(arrowX, 0)
          arrowX = Math.min(arrowX, @screen.width - 38)

          arrowY = (mob.y * @zoom) - @scrollY
          arrowY = Math.max(arrowY, 0)
          arrowY = Math.min(arrowY, @screen.height - 25)


          distX = (mob.x * @zoom) - (@scrollX + @screen.width / 2)
          distY = (mob.y * @zoom) - (@scrollY + @screen.height / 2)
          arrowRotation = Math.atan2(distY, distX)

          if mob instanceof LD24.Mobs.Bad
            spriteY = 32 + 25
          else if mob instanceof LD24.Mobs.PowerUp
            spriteY = 32
          @screen.render 768, spriteY, 38, 25, arrowX, arrowY, null, null, arrowRotation


  renderBackground: ->
    @screen.save()

    @screen.context.fillStyle = 'rgb(10,14,30)'
    @screen.context.fillRect 0, 0, @screen.width, @screen.height

    @screen.restore()