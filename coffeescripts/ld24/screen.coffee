window.LD24 ?= {}
window.LD24.Screen = class Screen
  constructor: (@canvas) ->
    @context = @canvas.get(0).getContext '2d'

    @width  = @canvas.width()
    @height = @canvas.height()

    @canvas.get(0).width = @width
    @canvas.get(0).height = @height

    @sprites = new Image()
    @sprites.src = 'assets/images/sprites.png'

  clear: ->
    @context.fillRect 0, 0, @width, @height

  render: (sx, sy, sw, sh, dx, dy, dw, dh, rotation=null) ->
    dw ?= sw
    dh ?= sh

    @save()
    if rotation?
      @context.translate dx + dw / 2, dy + dh / 2
      @context.rotate rotation

      @context.drawImage @sprites, sx, sy, sw, sh, Math.round(-dw / 2), -dh / 2, dw, dh
    else
      @context.drawImage @sprites, sx, sy, sw, sh, dx, dy, dw, dh

    @restore()

  save: -> @context.save()
  restore: -> @context.restore()