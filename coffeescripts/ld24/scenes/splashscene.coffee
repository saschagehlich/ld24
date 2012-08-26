window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.SplashScene = class SplashScene extends EventEmitter
  constructor: (@game, @screen) ->
    @zoom = 1
    @scrollX = 0
    @scrollY = 0

    @player = new LD24.Mobs.Player @game, this, @screen
    @player.scale = @player.toScale = 0.7

    @player.x = 200
    @player.y = 125

    @player.speedRotation = 0.5

    @particles = []
    @generateParticles()

    @mobs = [@player]

    $('canvas, .splash').fadeIn 'slow'
    @game.unpause()

    @selectedMenuItem = $('.menu .active')

    jwerty.key '↓', @selectNextItem
    jwerty.key '↑', @selectPrevItem
    jwerty.key 'enter', (e) =>
      $(document).unbind '.jwerty'

      if @selectedMenuItem.hasClass 'campaign'
        @game.loadCampaign()

      if @selectedMenuItem.hasClass 'endless'
        @game.loadEndless()

      if @selectedMenuItem.hasClass 'about'
        @showAbout()

    $('.menu li').mouseenter ->
      $('.menu li').removeClass 'active'
      $(this).addClass 'active'

    $('.campaign').click => @game.loadCampaign()
    $('.endless').click  => @game.loadEndless()
    $('li.about').click  => @showAbout()

    jwerty.key '↑,↑,↓,↓,←,→,←,→,B,A', =>
      for i in [0...100]
        mob = new LD24.Mob @game, this, @screen
        mob.x = @screen.width * Math.random()
        mob.y = @screen.height * Math.random()

        mob.scale = 0.0001
        mob.toScale =  0.1 + Math.random() * 0.3

        mob.toSpeedX = Math.random()
        if Math.round(Math.random()) is 0
          mob.toSpeedX *= -1
        mob.toSpeedY = Math.random()
        if Math.round(Math.random()) is 0
          mob.toSpeedY *= -1

        @mobs.push mob
      # gimmick: spawn 100 mobs automatically moving to the player and make him explode

  selectNextItem: =>
    nextItem = @selectedMenuItem.next('li')
    unless nextItem.length > 0
      nextItem = $('.menu li').first()
    $('.menu li').removeClass 'active'
    nextItem.addClass 'active'

    @selectedMenuItem = nextItem

  selectPrevItem: =>
    prevItem = @selectedMenuItem.prev('li')
    unless prevItem.length > 0
      prevItem = $('.menu li').last()
    $('.menu li').removeClass 'active'
    prevItem.addClass 'active'

    @selectedMenuItem = prevItem

  generateParticles: ->
    for i in [0...50]
      particle = new LD24.Particle @game, this, @screen
      particle.x = Math.random() * @screen.width
      particle.y = Math.random() * @screen.height

      particle.scale = Math.random()

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
    for particle in @particles
      particle.tick()

    for mob in @mobs
      if mob.removed
        @mobs = _.without @mobs, mob
      else
        mob.tick()

      for otherMob in @mobs
        # Intersection / Absorption
        if mob.intersects(otherMob) and otherMob isnt mob and not otherMob.absorbed
          mob.absorb otherMob

        # Attraction
        if otherMob isnt mob and 
          not otherMob.absorbed and 
          mob.attraction > 0 and 
          not (otherMob instanceof LD24.Mobs.PowerUp) and
          not (otherMob instanceof LD24.Mobs.Bad)
            mobRadius      = (mob.spriteW / 2 * mob.scale)
            otherMobRadius = (otherMob.spriteW / 2 * otherMob.scale)

            distX = mob.x - otherMob.x
            distY = mob.y - otherMob.y
            dist  = Math.sqrt(Math.pow(Math.abs(distX), 2) + Math.pow(Math.abs(distY), 2)) - mobRadius - otherMobRadius

            if dist < 100
              otherMob.speedX = distX / 50
              otherMob.speedY = distY / 50

  render: ->
    @renderBackground()

    for particle in @particles
      particle.render()

    for mob in @mobs
      mob.render()

  renderBackground: ->
    @screen.save()

    @screen.context.fillStyle = 'rgb(10,14,30)'
    @screen.context.fillRect 0, 0, @screen.width, @screen.height

    @screen.context.drawImage @screen.background, @scrollX / @zoom, @scrollY / @zoom, @screen.width / @zoom, @screen.height / @zoom, 0, 0, @screen.width, @screen.height

    @screen.restore()

  terminate: (callback) ->
    $('canvas').fadeOut 'slow'
    $('.splash').fadeOut 'slow', =>
      callback?()

  showAbout: ->
    @player.toOpacity = 0
    $('.splash').fadeOut 'slow', =>
      $('div.about').fadeIn 'slow'

    $('div.about .back').click => @hideAbout()

  hideAbout: ->
    $('div.about').fadeOut 'slow', =>
      @player.toOpacity = 1
      $('.splash').fadeIn 'slow'