window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Bad = class BadMob extends LD24.Mobs.Mote
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @scale = @toScale = Math.random() * 0.2

    @opacity = 1.0

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 256 * 2, 0, 256, 256, finalX, finalY, finalW, finalH

    # Render random red lines
    @screen.save()

    context = @screen.context
    context.strokeStyle = 'rgba(255, 0, 0, 0.1)'
    context.lineWidth = 3
    context.beginPath()
    context.moveTo finalW / 6 + finalX + Math.random() * finalW / 3 * 2, finalH / 6 + finalY + Math.random() * finalH / 3 * 2
    for i in [0...30]
      context.lineTo finalW / 6 + finalX + Math.random() * finalW / 3 * 2, finalH / 6 + finalY + Math.random() * finalH / 3 * 2

    context.closePath()
    context.stroke()

    @screen.restore()

  canBeAbsorbedBy: (mob) ->
    return false

  absorb: (mob) ->
    unless mob instanceof LD24.Mobs.Player
      return
    super mob