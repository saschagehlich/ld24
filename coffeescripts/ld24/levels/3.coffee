window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level3 = class Level3 extends LD24.Level
  name: 'Level 3'
  subname: 'No! Bad particle!'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text @name

    @game.showInfoBox 'Red particles are bad! They absorb everything, even if it\'s smaller than the other particles.'

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

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5
