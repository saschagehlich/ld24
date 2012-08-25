window.LD24 ?= {}
window.LD24.Game = class Game
  ticksPerSecond: 60
  framesPerSecond: 60
  constructor: (@canvas) ->
    @screen = new LD24.Screen this, @canvas
    @scene = new LD24.Scenes.Game this, @screen

    # @setupStats()
    @setupTickLoop()
    @setupRenderLoop()

  debug: (msg) ->
    $('.debug').text msg

  # Setup
  #######
  setupStats: ->
    @stats = new Stats
    @stats.setMode 0

    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.left = '0px'
    @stats.domElement.style.top = '0px'

    @canvas.parent().append @stats.domElement

  setupTickLoop: ->
    @tickLoop = every 1000 / @ticksPerSecond, =>
      @tick()

  setupRenderLoop: ->
    # requestAnimationFrame = window.requestAnimationFrame or window.mozRequestAnimationFrame or window.webkitRequestAnimationFrame or window.msRequestAnimationFrame
    # window.requestAnimationFrame = requestAnimationFrame
    @renderLoop = every 1000 / @framesPerSecond, =>
      @render()

  pause: ->
    clearInterval @tickLoop
    clearInterval @renderLoop

  # Tick
  ######
  tick: ->
    @scene.tick()

  render: (timestamp) =>
    @stats?.begin()
    
    @screen.clear()
    @scene.render()

    @stats?.end()