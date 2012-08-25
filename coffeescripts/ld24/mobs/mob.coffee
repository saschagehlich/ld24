JUMPSTATE_JUMPING = 1
JUMPSTATE_FALLING = 2

window.LD24 ?= {}
window.LD24.Mobs ?= {}
window.LD24.Mobs.Mob = class Mob
  spriteW: 16
  spriteH: 16
  constructor: (@game, @scene, @screen) ->
    @x = 0
    @y = @screen.height - @scene.fragment.floorHeight - @spriteH
    @removed = false

    @jumpThreshold = 0
    @jumpState     = null

    @jumpThresholdMax = 5
    @jumpThresholdReduction = 20
    @jumpThresholdTolerance = 0.3

    @gravity = 1

    @tickCount = 0

    @walkPosition = 0

  tick: ->
    if @jumpState is JUMPSTATE_JUMPING
      # Mob is jumping or falling

      @jumpThreshold -= @jumpThreshold / @jumpThresholdReduction
      @y -= @jumpThreshold

      if @jumpThreshold <= @jumpThresholdTolerance and @jumpState is JUMPSTATE_JUMPING
        @jumpState = JUMPSTATE_FALLING
        @jumpThreshold = 0

    @y += @gravity
    if @y >= @screen.height - @scene.fragment.floorHeight - @spriteH
      @y = @screen.height - @scene.fragment.floorHeight - @spriteH
      @jumpState = null

    @tickCount++

    if Math.abs(Math.round(@scene.offsetX)) % 10 is 0
      @walkPosition += 1

      if @walkPosition is @scene.fragment.gfx.mob.frames
        @walkPosition = 0

  render: ->
    drawSX = @scene.fragment.gfx.mob.spriteXOffset
    drawSX += @walkPosition * @spriteW
    @screen.render drawSX, @scene.fragment.gfx.mob.spriteY, @spriteW, @spriteH, @x + @scene.offsetX, @y

  remove: -> 
    @removed = true
  
  intersects: (mob) ->
    if @x + @spriteW < mob.x or @x > mob.x + mob.spriteW or 
      @y + @spriteH < mob.y or @y > mob.y + mob.spriteH
        return false  
    return true

  jump: =>
    unless @jumpState
      @jumpThreshold = @jumpThresholdMax
      @jumpState     = JUMPSTATE_JUMPING