window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Mote = class MoteMob extends LD24.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen