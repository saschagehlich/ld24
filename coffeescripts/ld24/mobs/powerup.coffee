window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.PowerUp = class PowerUpMob extends LD24.Mobs.Mote
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 256, 256, 256, 256, finalX, finalY, finalW, finalH
    @screen.render 256 * 2, 256, 256, 256, finalX - @speedX * 10, finalY - @speedY * 10, finalW, finalH, @rotation * (Math.PI/180)
    @screen.render 256 * 3, 256, 256, 256, finalX - @speedX * 10, finalY - @speedY * 10, finalW, finalH, @rotation * (Math.PI/180)

  canBeAbsorbedBy: (mob) ->
    if mob.scale > @scale and mob instanceof LD24.Mobs.Player
      return true
    return false