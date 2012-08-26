window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.GameScene = class GameScene extends EventEmitter
  constructor: (@game, @screen, @endless=false) ->
    @running = false

    @boundaryOffset = 480 / 3
    @defaultZoom    = 5

    if @endless
      if $.cookie('abs_el_lvl')?
        @levelNum = parseInt($.cookie('abs_el_lvl'))
      else
        @levelNum       = 1

      @levelsCount    = 999 # It's not endless. YES, I'M A LIAR!
    else
      if $.cookie('abs_tt_lvl')?
        @levelNum = parseInt($.cookie('abs_tt_lvl'))
      else
        @levelNum       = 1
      @levelsCount    = 5

    @reset()

  pause: ->
    unless @game.paused
      @game.pause()

      jwerty.key '↓', =>
        selectedItem = $('.ingame-menu .active')

        nextItem = selectedItem.next()
        if nextItem.length is 0
          nextItem = selectedItem.parent().find('li').first()

        selectedItem.parent().find('li').removeClass 'active'

        nextItem.addClass 'active'
      jwerty.key '↑', =>
        selectedItem = $('.ingame-menu .active')

        prevItem = selectedItem.prev()
        if prevItem.length is 0
          prevItem = selectedItem.parent().find('li').last()

        selectedItem.parent().find('li').removeClass 'active'
        prevItem.addClass 'active'

      jwerty.key 'enter', =>
        selectedItem = $('.ingame-menu .active')
        if selectedItem.hasClass 'continue'
          @pause()
        if selectedItem.hasClass 'retry'
          @unloadLevel()
          @game.unpause()
          $('.ingame-menu').fadeOut 'slow'
        if selectedItem.hasClass 'quit'
          @game.loadSplash()
          $('.ingame-menu').fadeOut 'slow'

      $('.ingame-menu').fadeIn 'slow'
    else
      @game.unpause()

      $(document).off '.jwerty'
      @handlePause()
      @player.handleKeyboard()

      $('.ingame-menu').fadeOut 'slow'

  handlePause: ->
    jwerty.key 'escape', =>
      @pause()

  reset: ->
    @player   = new LD24.Mobs.Player @game, this, @screen
    @player.x = @screen.width / 2
    @player.y = @screen.height / 2

    @player.scale = @player.toScale = 0.04
    @player.removeAllListeners 'absorb'
    @player.on 'absorb', (scale) =>
      # calculate size on screen
      size = @player.spriteW * scale * @zoom
      if size > @screen.width / 4
        @zoomOut()

    @zoom = @defaultZoom
    @toZoom = @zoom
    @scrollX = @screen.width / 2 * @zoom - @screen.width / 2
    @toScrollX = @scrollX
    @scrollY = @screen.height / 2 * @zoom - @screen.height / 2
    @toScrollY = @scrollY

    @mobs = [@player]
    @particles = []

    unless @endless
      @level = new LD24.Levels['Level' + @levelNum] @game, this, @screen
    else
      @level = new LD24.Levels.LevelEndless @game, this, @screen, @levelNum

    @level.once 'win', =>
      $('.level-progress').fadeOut 'slow'

      @player.absorbable = false

      @levelNum++

      if @endless
        $.cookie 'abs_el_lvl', @levelNum
      else
        $.cookie 'abs_tt_lvl', @levelNum

      if @levelNum > @levelsCount
        $('.level-complete').text('Well done!').fadeIn 'slow'
        $('.level-complete-detail').text('You have completed all campaign levels.').fadeIn 'slow'          
        $('div.continue').text('Press [ENTER] to go to the main menu.').fadeIn 'slow'          
        $(document).off '.jwerty'

        jwerty.key 'enter', =>
          @game.loadSplash()
      else
        $('.level-complete').text('Level complete').fadeIn 'slow'
        $(document).off '.jwerty'

        after 2000, =>
          @unloadLevel()

    @level.on 'lost', (reason='You have been absorbed by a bigger particle.') =>
      $('.level-progress').fadeOut 'slow'
      $('.level-complete').text('Game Over!').fadeIn 'slow'
      $('.level-complete-detail').text(reason).fadeIn 'slow'
      $('div.continue').fadeIn 'slow'

      @canReset = true

      jwerty.key 'enter', =>
        if @canReset
          @unloadLevel()
          @canReset = false


    unless navigator.userAgent.match /Firefox/
      @generateParticles()
    @loadLevel()

  unloadLevel: ->
    @level.terminate()

    $(document).off '.jwerty'
    $(document).off 'keydown'

    $('.level-complete').fadeOut 'slow'
    $('.level-complete-detail').fadeOut 'slow'
    $('div.continue').fadeOut 'slow'
    $('.level-progress .done').css width: '0'
    $('canvas').fadeOut 'slow', =>
      @reset()
      @running = false

  loadLevel: ->
    $('.level-complete').text @level.name
    $('.level-complete-detail').text @level.subname

    $('.level-complete').fadeIn 'slow'
    $('.level-progress .done').css width: 0
    $('.level-complete-detail').fadeIn 'slow', =>
      after 2000, =>
        $('.level-complete').fadeOut 'slow'
        $('.level-complete-detail').fadeOut 'slow', =>

          @running = true

          @handlePause()

          $('canvas').fadeIn 'slow'
          $('.level-progress').fadeIn 'slow'

  zoomOut: ->
    @toZoom = Math.max 1, @toZoom - 1

    # linear zoomOut
    # @toScrollX = @scrollX / @zoom * @toZoom
    # @toScrollY = @scrollY / @zoom * @toZoom
    

  zoomIn: ->
    @toZoom = Math.min 5, @toZoom + 1

    # linear zoomIn
    # @toScrollX = @scrollX / @zoom * @toZoom
    # @toScrollY = @scrollY / @zoom * @toZoom

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
    @zoom += (@toZoom - @zoom) / 20

    # scroll transition
    @scrollX += (@toScrollX - @scrollX) / 10
    @scrollY += (@toScrollY - @scrollY) / 10

    for particle in @particles
      particle.tick()

    # boundary scrolling
    if @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale < @scrollY + @boundaryOffset
      @toScrollY = @player.y * @zoom - @player.spriteH / 2 * @zoom * @player.scale - @boundaryOffset
    else if @player.y * @zoom + @player.spriteH / 2 * @zoom * @player.scale > @scrollY + @screen.height - @boundaryOffset
      @toScrollY = @player.y * @zoom - @screen.height + @player.spriteH / 2 * @zoom * @player.scale + @boundaryOffset

    if @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale < @scrollX + @boundaryOffset
      @toScrollX = @player.x * @zoom - @player.spriteW / 2 * @zoom * @player.scale - @boundaryOffset
    else if @player.x * @zoom + @player.spriteW / 2 * @zoom * @player.scale > @scrollX + @screen.width - @boundaryOffset
      @toScrollX = @player.x * @zoom - @screen.width + @player.spriteW / 2 * @zoom * @player.scale + @boundaryOffset

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
        # Intersection / Absorption
        if mob.intersects(otherMob) and otherMob isnt mob and not otherMob.absorbed
          mob.absorb otherMob

        # Attraction
        if otherMob isnt mob and 
          not otherMob.absorbed and 
          mob.attraction > 0 and 
          not (otherMob instanceof LD24.Mobs.PowerUp) and
          not (otherMob instanceof LD24.Mobs.Bad) and
          otherMob.scale < mob.scale
            mobRadius      = (mob.spriteW / 2 * mob.scale)
            otherMobRadius = (otherMob.spriteW / 2 * otherMob.scale)

            distX = mob.x - otherMob.x
            distY = mob.y - otherMob.y
            dist  = Math.sqrt(Math.pow(Math.abs(distX), 2) + Math.pow(Math.abs(distY), 2)) - mobRadius - otherMobRadius

            if dist < 100
              otherMob.speedX = distX / 50
              otherMob.speedY = distY / 50

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
          else if mob instanceof LD24.Mobs.PowerUpSpeed
            spriteY = 32
          else if mob instanceof LD24.Mobs.PowerUpAttraction
            spriteY = 32 + 25*2

          @screen.render 768, spriteY, 38, 25, arrowX, arrowY, null, null, arrowRotation

    @renderPowerUpIcons()


  renderPowerUpIcons: ->
    x = 89
    if @player.isAttractive()
      @screen.render 0, 768, 28, 28, x, 410
      x += 28 + 5

    if @player.isSpeedy()    
      @screen.render 28, 768, 28, 28, x, 410
      x += 28 + 5

    if @player.isProtected()
      @screen.render 56, 768, 28, 28, x, 410
      x += 28 + 5


  renderBackground: ->
    @screen.save()

    @screen.context.fillStyle = 'rgb(10,14,30)'
    @screen.context.fillRect 0, 0, @screen.width, @screen.height

    sx = @scrollX / @zoom
    sy = @scrollY / @zoom
    sw = @screen.width - sx
    sh = @screen.height - sy


    @screen.context.drawImage @screen.background, sx, sy, sw, sh, 0, 0, @screen.width, @screen.height

    @screen.restore()

  terminate: (callback) ->
    $('.level-progress, .level-complete, .level-complete-detail, div.continue').fadeOut 'slow'
    @game.hideInfoBox()

    $(document).off '.jwerty'
    $(document).off 'keydown'

    $('canvas').fadeOut 'slow', =>
      callback?()