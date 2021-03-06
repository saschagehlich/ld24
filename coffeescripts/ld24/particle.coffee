window.LD24 ?= {}
window.LD24.Particle = class Particle
  spriteW: 32
  spriteH: 32
  constructor: (@game, @scene, @screen) ->
    @x = 0
    @y = 0

    @speedX = 0
    @speedY = 0

    @scrollX = 0
    @scrollY = 0

    @scale = Math.random() * 0.3
    @opacity = Math.random() * 0.4

    @spriteX = Math.round(Math.random() * 2) * 32

  tick: ->
    @x += @speedX
    @y += @speedY

    # Make the particles endless
    if @x > @screen.width
      @x = -32 * @scale
    if @x < -32 * @scale
      @x = @screen.width

    if @y > @screen.height
      @y = -32 * @scale
    if @y < -32 * @scale / 2
      @y = @screen.height

  render: ->
    finalW = 32 * @scene.zoom * @scale
    finalH = 32 * @scene.zoom * @scale
    finalX = @x * @scene.zoom - @scene.scrollX
    finalY = @y * @scene.zoom - @scene.scrollY

    @screen.save()
    @screen.context.globalAlpha = @opacity
    @screen.render 768 + @spriteX, 0, 32, 32, finalX, finalY, finalW, finalH
    @screen.restore()