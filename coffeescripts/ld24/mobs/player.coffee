window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Player = class Player extends LD24.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @totalMaxSpeed = @maxSpeed = 1

    @powerupSpeed = false
    @powerupSpeedEndTick = 0

    @handleKeyboard()

    @opacity = 1.0

    @protected = true
    @protectedEndTick = 60*2

    @absorbable = true # we use that to "lock" the player as soon as he wins

  tick: -> 
    super()

    if @powerupSpeed and @tickCount > @powerupSpeedEndTick
      @maxSpeed = @totalMaxSpeed
      @powerupSpeed = false

    if @protected and @tickCount > @protectedEndTick
      @protected = false

  render: ->
    super()

    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 0, 256, 256, 256, finalX - @speedX * 2 * @scene.zoom, finalY - @speedY * 2 * @scene.zoom, finalW, finalH

  absorb: (mob) ->
    if not @absorbing and mob.canBeAbsorbedBy(@)
      @toScale = @scale + mob.scale / 2
      mob.absorbedBy @

      @emit 'absorb', @toScale
      @game.sounds.playSound 'absorb'


  canBeAbsorbedBy: (mob) ->
    if @protected or !@absorbable
      return false

    if mob instanceof LD24.Mobs.Bad
      return true

    if @scale > mob.scale
      return false
    return true

  handleKeyboard: ->
    @up = false
    @left = false
    @down = false
    @right = false

    $(document).keydown (e) =>
      if jwerty.is('down', e) or jwerty.is('s', e)
        @toSpeedY = 1 * @maxSpeed
        @down = true
      else if jwerty.is('up', e) or jwerty.is('w', e)
        @toSpeedY = -1 * @maxSpeed
        @up = true
      else if jwerty.is('left', e) or jwerty.is('a', e)
        @toSpeedX = -1 * @maxSpeed
        @left = true
      else if jwerty.is('right', e) or jwerty.is('d', e)
        @toSpeedX = 1 * @maxSpeed
        @right = true

    $(document).keyup (e) =>
      if jwerty.is('down', e) or 
        jwerty.is('s', e)
          @toSpeedY = 0
          if @up
            @toSpeedY = -1 * @maxSpeed
          @down = false

      if jwerty.is('up', e) or
        jwerty.is('w', e)
          @toSpeedY = 0
          if @down
            @toSpeedY = @maxSpeed
          @up = false

      if jwerty.is('left', e) or
        jwerty.is('a', e)
          @toSpeedX = 0
          if @right
            @toSpeedX = @maxSpeed
          @left = false

      if jwerty.is('right', e) or 
        jwerty.is('d', e)
          @toSpeedX = 0
          if @left
            @toSpeedX = -1 * @maxSpeed
          @right = false
