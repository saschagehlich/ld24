window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Player = class Player extends LD24.Mobs.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

  tick: ->