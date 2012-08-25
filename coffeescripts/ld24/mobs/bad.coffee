window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Bad = class BadMob extends LD24.Mobs.Mote
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @scale = @toScale = Math.random() * 0.2

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 256 * 2, 0, 256, 256, finalX, finalY, finalW, finalH

  canBeAbsorbedBy: (mob) ->
    return false