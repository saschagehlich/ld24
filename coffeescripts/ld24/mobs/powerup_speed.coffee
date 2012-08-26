window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.PowerUpSpeed = class PowerUpSpeedMob extends LD24.Mobs.PowerUp
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

  absorbedBy: (mob) ->
    super mob
    
    mob.powerupSpeed = true
    mob.powerupSpeedEndTick = mob.tickCount + 60 * 10
    mob.maxSpeed = 3