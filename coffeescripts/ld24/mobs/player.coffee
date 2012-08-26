window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Player = class Player extends LD24.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @maxSpeed = 1

    @powerupSpeed = false
    @powerupSpeedEndTick = 0

    @handleKeyboard()

    @opacity = 1.0

  tick: -> 
    super()

    if @powerupSpeed and @tickCount > @powerupSpeedEndTick
      @maxSpeed = 1
      @powerupSpeed = false

  render: ->
    super()

    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 0, 256, 256, 256, finalX, finalY, finalW, finalH

  absorb: (mob) ->
    if not @absorbing and mob.canBeAbsorbedBy(@)
      @toScale = @scale + mob.scale / 2
      @absorbing = true

      mob.once 'absorbed', =>
        @absorbing = false
      mob.absorbedBy @

      @emit 'absorb', @toScale
      @game.sounds.playSound 'absorb'


  canBeAbsorbedBy: (mob) ->
    if mob instanceof LD24.Mobs.Bad
      return true

    if @scale > mob.scale
      return false
    return true

  handleKeyboard: ->
    $(document).keydown (e) =>
      if jwerty.is('down', e) or jwerty.is('s', e)
        @toSpeedY = 1 * @maxSpeed
      else if jwerty.is('up', e) or jwerty.is('w', e)
        @toSpeedY = -1 * @maxSpeed
      else if jwerty.is('left', e) or jwerty.is('a', e)
        @toSpeedX = -1 * @maxSpeed
      else if jwerty.is('right', e) or jwerty.is('d', e)
        @toSpeedX = 1 * @maxSpeed

    $(document).keyup (e) =>
      if jwerty.is('down', e) or 
        jwerty.is('up', e) or
        jwerty.is('w', e) or 
        jwerty.is('s', e)
          @toSpeedY = 0
      if jwerty.is('left', e) or
        jwerty.is('right', e) or 
        jwerty.is('a', e) or 
        jwerty.is('d', e)
          @toSpeedX = 0