window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level1 = class Level1 extends LD24.Level
  name: 'Level 1'
  subname: 'The Beginning'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text 'Level 1'

    @game.showInfoBox 'Use the arrow keys or WASD on your keyboard to move your dust particle and to absorb smaller dust particles.'

    # Only normal mobs
    for i in [0...60]
      scale = 0.01 + Math.random() * 0.03
      @addNormalMobs 1, scale

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5