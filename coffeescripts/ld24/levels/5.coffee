window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level5 = class Level5 extends LD24.Level
  name: 'Level 5'
  subname: 'Quite Attractive'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text @name

    @game.showInfoBox 'Blue power ups are attraction power ups. Your dust particle attracts good mobs for some time.'

    # Only normal mobs, but also bigger ones
    for i in [0...30]
      scale = 0.01 + Math.random() * 0.03
      @addNormalMobs 1, scale

    # for i in [0...30]
    #   scale = 0.01 + Math.random() * 0.1
    #   @addNormalMobs 1, scale

    # for i in [0...5]
    #   scale = 0.01 + Math.random() * 0.1
    #   @addBadMobs 1, scale

    for i in [0...3]
      scale = 0.03 + Math.random() * 0.1
      @addAttractionPowerUps 1, scale

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5
