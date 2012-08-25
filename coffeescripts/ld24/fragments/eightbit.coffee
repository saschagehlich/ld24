window.LD24 ?= {}
window.LD24.Fragments ?= {}
window.LD24.Fragments.EightBit = class EightBitFragment extends LD24.Fragments.Fragment
  width: 3000
  floorHeight: 16

  # Mob sprites change everytime we enter a new fragment
  gfx:
    player:
      frames: 4
      spriteY: 32
      spriteXOffset: 16
    mob:
      frames: 4
      spriteY: 32
      spriteXOffset: 16 * 5
    font:
      spriteY: 48

  constructor: (@game, @scene, @screen) ->
    @offsetX = 0

  tick: ->

  render: ->
    for i in [0...@width / 16]
      drawX = i * 16 + @offsetX
      if drawX > -16 and drawX < @screen.width
        @screen.render 0, 32, 16, 16, drawX, @screen.height - 16