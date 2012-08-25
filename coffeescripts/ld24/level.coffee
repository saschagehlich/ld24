window.LD24 ?= {}
window.LD24.Level = class Level
  constructor: (@game, @scene, @screen) ->
    @progressDoneDisplayer = $('.progress .done')
    @levelNumDisplayer     = $('.level')

  addNormalMobs: (count) ->
    # Normal mobs
    for i in [0...count]
      mob = new LD24.Mobs.Mote @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  addPowerUps: (count) ->
    # Power ups
    for i in [0...count]
      mob = new LD24.Mobs.PowerUp @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob

  addBadMobs: (count) ->
    # Bad mobs
    for i in [0...count]
      mob = new LD24.Mobs.Bad @game, @scene, @screen
      mob.x = Math.random() * @screen.width
      mob.y = Math.random() * @screen.height

      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedX *= -1
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed
      if Math.round(Math.random()) is 0
        mob.speedY *= -1

      @scene.mobs.push mob