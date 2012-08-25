window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Mob = class Mob
  spriteX: 16
  spriteY: 0
  spriteW: 16
  spriteH: 16
  constructor: (@game, @scene, @screen) ->
    @x = 0
    @y = @screen.height - @scene.fragment.floorHeight - @spriteH
    @removed = false

  tick: -> 
  render: ->
    @screen.render @spriteX, @spriteY, @spriteW, @spriteH, @x + @scene.offsetX, @y

  remove: -> 
    @removed = true
  
  intersects: (mob) ->
    if @x + @spriteW < mob.x or @x > mob.x + mob.spriteW or 
      @y + @spriteH < mob.y or @y > mob.y + mob.spriteH
        return false  
    return true