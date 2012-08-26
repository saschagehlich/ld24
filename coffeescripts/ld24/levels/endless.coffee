window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.LevelEndless = class LevelEndless extends LD24.Level
  name: 'Endless Game'
  subname: 'Absorb ALL the Particles!'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen
    @levelNumDisplayer.text @name

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

    for i in [0...3]
      scale = 0.03 + Math.random() * 0.1
      @addAttractionPowerUps 1, scale