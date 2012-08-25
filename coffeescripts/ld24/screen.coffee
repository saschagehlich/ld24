window.LD24 ?= {}
window.LD24.Screen = class Screen
  constructor: (@game, @canvas) ->
    @context = @canvas.get(0).getContext '2d'

    @canvas.get(0).width = @width = @canvas.width()
    @canvas.get(0).height = @height = @canvas.height()

    @sprites = new Image
    @sprites.src = 'assets/images/sprites.png'
    @sprites.onload = =>
      console.log "sprites loaded"

  clear: ->
    @context.fillRect 0, 0, @width, @height

  render: (sx, sy, sw, sh, dx, dy, dw, dh) ->
    dw ?= sw
    dh ?= sh

    @context.drawImage @sprites, sx, sy, sw, sh, dx, dy, dw, dh

  save:    -> @context.save()
  restore: -> @context.restore()

  drawText: (text, x, y) ->
    chars = '1234567890m'
    for char, i in text
      @render chars.indexOf(char) * 8, @game.scene.fragment.gfx.font.spriteY, 8, 8, x + 8 * i, y