window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level4 = class Level4 extends LD24.Level
  name: 'Level 4'
  subname: 'Currere Velocius'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text @name

    @game.showInfoBox 'Powerups are indicated by a rotation dashed border. Green power ups give you a speed boost for a few seconds.'

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
      @addPowerUps 1, scale

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5
