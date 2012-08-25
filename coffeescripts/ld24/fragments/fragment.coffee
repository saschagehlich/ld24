window.LD24 ?= {}
window.LD24.Fragments ?= {}
window.LD24.Fragments.Fragment = class Fragment
  width: 1000
  constructor: (@game, @scene, @screen) ->
    @offsetX = 0
  tick: -> null
  render: -> null