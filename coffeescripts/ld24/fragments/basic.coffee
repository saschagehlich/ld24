window.LD24 ?= {}
window.LD24.Fragments ?= {}
window.LD24.Fragments.Basic = class BasicFragment extends LD24.Fragments.Fragment
  width: 9000
  floorHeight: 16
  constructor: (@game, @scene, @screen) ->

  tick: ->

  render: ->
    for i in [0...@width / 16]
      drawX = i * 16 + @scene.offsetX
      if drawX > -15 and drawX < @screen.width
        @screen.render 0, 0, 16, 16, drawX, @screen.height - 16