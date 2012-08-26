window.LD24 ?= {}
window.LD24.Game = class Game
  framesPerSecond: 60
  version: "0.2"
  constructor: (@canvas) ->
    @screen = new LD24.Screen @canvas
    unless $.cookie('abs_intro_seen') is '1'
      @scene  = new LD24.Scenes.IntroScene this, @screen
    else
      @scene  = new LD24.Scenes.SplashScene this, @screen
    @sounds = new LD24.Sounds this

    @sounds.on 'loaded', =>
      @sounds.playSoundtrack()

    @setupTickLoop()
    @setupRenderLoop()

    $('.version').text @version

    @paused = false

    $(document).keydown (e) =>
      if e.keyCode is 80
        unless @paused
          @pause()
        else
          @unpause()

  showInfoBox: (message) ->
    $('.info-box .text').text message
    $('.info-box').css marginTop: -5, opacity: 0, display: 'block'
    $('.info-box').animate marginTop: 0, opacity: 0.8, 'slow'

    $('.info-box .close').click => @hideInfoBox()

  hideInfoBox: ->
    $('.info-box').fadeOut 'fast'

  loadCampaign: ->
    @scene.terminate =>
      @scene = new LD24.Scenes.GameScene this, @screen

  loadEndless: ->
    @scene.terminate =>
      @scene = new LD24.Scenes.GameScene this, @screen, true

  loadSplash: ->
    @scene.terminate =>
      @scene = new LD24.Scenes.SplashScene this, @screen

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
    if @paused
      return
    
    @paused = true
    clearInterval @tickLoop
    clearInterval @renderLoop

  unpause: ->
    unless @paused
      return

    @paused = false
    @setupTickLoop()
    @setupRenderLoop()

  debug: (msg) ->
    $('.debug').show().text msg