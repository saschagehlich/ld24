window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Player = class Player extends LD24.Mobs.Mob
  constructor: (@game, @scene, @screen) ->
    super @game, @scene, @screen

    @handleKeyboard()

  handleKeyboard: ->
    jwerty.key 'space', @jump

  render: ->
    drawSX = @scene.fragment.gfx.player.spriteXOffset
    drawSX += @walkPosition * @spriteW
    @screen.render drawSX, @scene.fragment.gfx.player.spriteY, @spriteW, @spriteH, @x + @scene.offsetX, @y