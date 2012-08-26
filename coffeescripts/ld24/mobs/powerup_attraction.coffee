window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.PowerUpAttraction = class PowerUpAttractionMob extends LD24.Mobs.PowerUp
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

  absorbedBy: (mob) ->
    super mob

    mob.powerupAttraction = true
    mob.powerupAttractionEndTick = mob.tickCount + 60 * 10
    mob.attraction = 10

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 256, 512, 256, 256, finalX, finalY, finalW, finalH
    @screen.render 0, 512, 256, 256, finalX - @speedX * 10, finalY - @speedY * 10, finalW, finalH, @borderRotation * (Math.PI/180)