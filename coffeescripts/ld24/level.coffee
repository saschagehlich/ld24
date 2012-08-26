window.LD24 ?= {}
window.LD24.Level = class Level extends EventEmitter
  constructor: (@game, @scene, @screen) ->
    @progressDoneDisplayer = $('.progress .done')
    @levelNumDisplayer     = $('.level')

    @scene.player.on 'absorb', @playerAbsorbedMob
    @scene.player.on 'absorbed', @playerGotAbsorbed

  playerAbsorbedMob: (scale) =>
    percentDone = Math.round(100 / @goalScale * scale)
    percentDone = Math.min percentDone, 100

    @progressDoneDisplayer.stop().animate width: percentDone + '%', 'fast'

    if percentDone >= 100
      @won()

  playerGotAbsorbed: (absorbingMob) =>
    @lost absorbingMob

  won: ->
    @game.hideInfoBox()
    @emit 'win'

  lost: (absorbingMob) ->
    @game.hideInfoBox()

    if absorbingMob instanceof LD24.Mobs.Bad
      @emit 'lost', 'You ran into a red particle. It absorbed you.'
    else
      @emit 'lost'

  addNormalMobs: (count, scale) ->
    # Normal mobs
    for i in [0...count]
      mob = new LD24.Mobs.Mote @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.scale = mob.toScale = scale

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  addSpeedPowerUps: (count, scale) ->
    # Power ups
    for i in [0...count]
      mob = new LD24.Mobs.PowerUpSpeed @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.scale = mob.toScale = scale

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  addAttractionPowerUps: (count, scale) ->
    # Power ups
    for i in [0...count]
      mob = new LD24.Mobs.PowerUpAttraction @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.scale = mob.toScale = scale

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  addBadMobs: (count, scale) ->
    # Bad mobs
    for i in [0...count]
      mob = new LD24.Mobs.Bad @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.scale = mob.scaleTo = scale

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  terminate: ->
    @scene.player.removeListener 'absorb', @playerAbsorbedMob
    @scene.player.removeListener 'absorbed', @playerGotAbsorbed