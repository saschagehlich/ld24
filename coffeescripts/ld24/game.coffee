window.LD24 ?= {}
window.LD24.Game = class Game
  framesPerSecond: 60
  constructor: (@canvas) ->
    @screen = new LD24.Screen @canvas
    @scene  = new LD24.Scenes.SplashScene this, @screen

    # @scene.on 'win', =>
    #   console.log 'player won'

    # @scene.on 'lose', =>
    #   console.log 'player lost'

    @setupTickLoop()
    @setupRenderLoop()

    jwerty.key 'p', =>
      @pause()

  loadCampaign: ->
    @scene.terminate =>
      @scene = new LD24.Scenes.GameScene this, @screen

  setupTickLoop: ->
    @tickLoop = every 1000 / @framesPerSecond, =>
      @tick()

  setupRenderLoop: ->
    @renderLoop = every 1000 / @framesPerSecond, =>
      @render()

  tick: ->
    @scene.tick()

  render: ->
    @screen.clear()    
    @scene.render()

  pause: ->
    clearInterval @tickLoop
    clearInterval @renderLoop

  debug: (msg) ->
    $('.debug').show().text msg