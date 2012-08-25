window.LD24 ?= {}
window.LD24.Fragments ?= {}
window.LD24.Fragments.Basic = class BasicFragment extends LD24.Fragments.Fragment
  width: 320
  floorHeight: 16

  # Mob sprites change everytime we enter a new fragment
  gfx:
    player:
      frames: 1
      spriteY: 0
      spriteXOffset: 16
    mob:
      frames: 1
      spriteY: 0
      spriteXOffset: 16
    font:
      spriteY: 16

  constructor: (@game, @scene, @screen) ->
    @offsetX = 0

  tick: ->

  render: ->
    for i in [0...@width / 16]
      drawX = i * 16 + @offsetX
      if drawX > -15 and drawX < @screen.width
        @screen.render 0, 0, 16, 16, drawX, @screen.height - 16