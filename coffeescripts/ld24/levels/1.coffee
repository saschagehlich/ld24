window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level1 = class Level1 extends LD24.Level
  name: 'Level 1'
  subname: 'The Beginning'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text 'Level 1'

    # Only normal mobs
    @addNormalMobs 60

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5

    @scene.player.on 'absorb', (scale) =>
      percentDone = Math.round(100 / @goalScale * scale)
      percentDone = Math.min percentDone, 100

      @progressDoneDisplayer.stop().animate width: percentDone + '%', 'fast'

      if percentDone >= 100
        @emit 'win'
