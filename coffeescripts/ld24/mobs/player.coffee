window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Player = class Player extends LD24.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @maxSpeed = 1

    @handleKeyboard()

  tick: -> 
    super()

  render: ->
    super()

    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 0, 256, 256, 256, finalX, finalY, finalW, finalH

  handleKeyboard: ->
    $(document).keydown (e) =>
      if jwerty.is 'down', e
        @toSpeedY = 1 * @maxSpeed
      else if jwerty.is 'up', e
        @toSpeedY = -1 * @maxSpeed
      else if jwerty.is 'left', e
        @toSpeedX = -1 * @maxSpeed
      else if jwerty.is 'right', e
        @toSpeedX = 1 * @maxSpeed

    $(document).keyup (e) =>
      if jwerty.is('down', e) or 
        jwerty.is('up', e)
          @toSpeedY = 0
      if jwerty.is('left', e) or
        jwerty.is('right', e)
          @toSpeedX = 0