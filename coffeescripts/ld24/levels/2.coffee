window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.Level2 = class Level2 extends LD24.Level
  name: 'Level 2'
  subname: 'Determined to Fight'
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @levelNumDisplayer.text @name

    @game.showInfoBox 'Be careful: Bigger mobs can absorb you as well. Try getting bigger than them before touching them.'

    # Only normal mobs, but also bigger ones
    for i in [0...30]
      scale = 0.01 + Math.random() * 0.03
      @addNormalMobs 1, scale

    for i in [0...30]
      scale = 0.01 + Math.random() * 0.1
      @addNormalMobs 1, scale

    # Calculate maximum reachable scale
    @goalScale = 0
    for mob in @scene.mobs
      @goalScale += mob.scale / 5

    @scene.player.on 'absorb', @playerAbsorbedMob
    @scene.player.on 'absorbed', @playerGotAbsorbed

  playerAbsorbedMob: (scale) =>
    percentDone = Math.round(100 / @goalScale * scale)
    percentDone = Math.min percentDone, 100

    @progressDoneDisplayer.stop().animate width: percentDone + '%', 'fast'

    if percentDone >= 100
      @won()

  playerGotAbsorbed: =>
    @lost()

  won: ->
    @game.hideInfoBox()
    @emit 'win'

  lost: ->
    @game.hideInfoBox()
    @emit 'lost'

  terminate: ->
    @scene.player.removeListener 'absorb', @playerAbsorbedMob
