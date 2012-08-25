window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.Game = class GameScene
  constructor: (@game, @screen) ->
    @offsetX = 0
    @tickCount = 0
    @speedX = 1

    @fragment     = new LD24.Fragments.Basic @game, this, @screen
    @nextFragment = null

    @player       = new LD24.Mobs.Player @game, this, @screen

    @mobs = []

  render: ->
    @fragment.render()
    @nextFragment?.render()
    @player.render()

    @renderGUI()

    for mob in @mobs
      mob.render()

  renderGUI: ->
    @screen.save()

    @screen.context.fillStyle = 'rgba(255,255,255,1)'
    @screen.context.fillRect 0, 0, @screen.width, 16

    # travelled meters
    @screen.drawText @getTravelledMeters() + 'm', 8, 4

    @screen.restore()

  tick: ->
    @offsetX -= @speedX
    @fragment.offsetX -= @speedX
    @nextFragment?.offsetX -= @speedX

    @player.x = @offsetX * -1 + 20

    @speedX += 0.0001

    @fragment.tick()
    @nextFragment?.tick()
    @player.tick()

    # Randomly spawn new mobs
    if @tickCount % 20 is 0
      if Math.floor(Math.random()*10) is 0
        mob = new LD24.Mobs.Mob @game, this, @screen
        mob.x = @offsetX * -1 + @screen.width
        @mobs.push mob

    for mob in @mobs
      if mob.x < @offsetX * -1 - 16
        mob.remove()

      if mob.removed
        @mobs = _.without @mobs, mob

      mob.tick()

      # check for intersection with player
      # if @player.intersects mob
      #   @game.pause()

    @tickCount++

    if Math.abs(@fragment.offsetX) >= @fragment.width - @screen.width and not @nextFragment
      @nextFragment = new LD24.Fragments.EightBit @game, this, @screen
      @nextFragment.offsetX = @screen.width

    if Math.abs(@fragment.offsetX) >= @fragment.width
      @fragment = @nextFragment
      @nextFragment = null

      console.log "setting current fragment"

  getTravelledMeters: ->
    Math.round Math.abs(@offsetX) / 16