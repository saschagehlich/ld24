window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level5 = class Level5 extends LD24.Level
  name: 'Level 5'
  subname: 'Quite Attractive'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text @name

    @game.showInfoBox 'Blue power ups are attraction power ups. They let your dust particle attract other particles for some time.'

    # Only normal mobs, but also bigger ones
    for i in [0...30]
      scale = 0.01 + Math.random() * 0.03
      @addNormalMobs 1, scale

    for i in [0...30]
      scale = 0.01 + Math.random() * 0.1
      @addNormalMobs 1, scale

    for i in [0...5]
      scale = 0.01 + Math.random() * 0.1
      @addBadMobs 1, scale

    for i in [0...2]
      scale = 0.03 + Math.random() * 0.1
      @addSpeedPowerUps 1, scale

    # spawn power up nearby
    scale = 0.03 + Math.random() * 0.1
    powerupX = @scene.scrollX / @scene.zoom + Math.random() * @screen.width / @scene.zoom
    powerupY = @scene.scrollY / @scene.zoom + Math.random() * @screen.height / @scene.zoom
    @addAttractionPowerUps 1, scale, powerupX, powerupY

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5
