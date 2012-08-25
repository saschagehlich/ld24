window.LD24 ?= {}
window.LD24.Particle = class Particle
  constructor: (@game, @scene, @screen) ->
    @x = 0
    @y = 0

    @speedX = 0
    @speedY = 0

    @scrollX = 0
    @scrollY = 0

    @spriteX = Math.round(Math.random())

    @scale = Math.random() * 0.3

  tick: ->
    @x += @speedX
    @y += @speedY

  render: ->
    @scrollX += (@scene.toScrollX - @scene.scrollX) / (100 * (0.3 - @scale))
    @scrollY += (@scene.toScrollY - @scene.scrollY) / (100 * (0.3 - @scale))

    finalW = 32 * @scene.zoom * @scale
    finalH = 32 * @scene.zoom * @scale
    finalX = @x * @scene.zoom - @scrollX
    finalY = @y * @scene.zoom - @scrollY

    @screen.render 768 + @spriteX * 32, 0, 32, 32, finalX, finalY, finalW, finalH