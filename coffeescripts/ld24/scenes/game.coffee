window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.Game = class GameScene
  constructor: (@game, @screen) ->
    @offsetX = 0
    @tickCount = 0

    @fragment = new LD24.Fragments.Basic @game, this, @screen
    @player   = new LD24.Mobs.Player @game, this, @screen

    @mobs = []

  render: ->
    @fragment.render()
    @player.render()

    for mob in @mobs
      mob.render()

  tick: ->
    @offsetX -= 1
    @player.x = @offsetX * -1 + 20

    @fragment.tick()
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
      if @player.intersects mob
        @game.pause()

    @tickCount++