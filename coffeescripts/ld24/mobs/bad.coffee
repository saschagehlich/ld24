window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Bad = class BadMob extends LD24.Mobs.Mote
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

  canBeAbsorbedBy: (mob) ->
    return false