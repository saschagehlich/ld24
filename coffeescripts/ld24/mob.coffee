window.LD24 ?= {}
window.LD24.Mob = class Mob extends EventEmitter
  spriteW: 256
  spriteH: 256
  spriteX: 0
  spriteY: 0
  constructor: (@game, @scene, @screen) ->
    @scale = 0.01 + Math.random() * 0.03
    @toScale = @scale

    @x = 0
    @y = 0

    @speedX = 0
    @speedY = 0
    @toSpeedX = 0
    @toSpeedY = 0

    @maxSpeed = 0.1

    @absorbed = false
    @absorbing = false
    @absorbingMob = null

    @rotation = 0
    @speedRotation = Math.random() * 0.5

  tick: ->
    unless @absorbingMob?
      @speedX += (@toSpeedX - @speedX) / 20
      @speedY += (@toSpeedY - @speedY) / 20

      @x += @speedX
      @y += @speedY
    else
      if @absorbingMob
        @toX = @absorbingMob.x
        @toY = @absorbingMob.y

      @x += (@toX - @x) / 10
      @y += (@toY - @y) / 10

    @scale += (@toScale - @scale) / 10
    if @scale < 0.01
      @emit "absorbed"
      @remove()

    @rotation += @speedRotation

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.render 0, 0, 256, 256, finalX, finalY, finalW, finalH
    @screen.render 256, 0, 256, 256, finalX - @speedX * 10, finalY - @speedY * 10, finalW, finalH, @rotation * (Math.PI/180)

  intersects: (mob) ->
    # circular intersection
    dx = Math.abs(@x - mob.x)
    dy = Math.abs(@y - mob.y)
    d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))

    if d > mob.spriteW * mob.scale / 2 + @spriteW * @scale / 2
      return false

    # rectangular intersection
    # if @x + @spriteW * @scale / 2 < mob.x - mob.spriteW * mob.scale / 2 or
    #   @x - @spriteW * @scale / 2 > mob.x + mob.spriteW * mob.scale / 2 or
    #   @y + @spriteH * @scale / 2 < mob.y - mob.spriteH * mob.scale / 2 or
    #   @y - @spriteW * @scale / 2 > mob.y + mob.spriteH * mob.scale / 2
    #     return false
    return true

  absorbedBy: (mob) ->
    @absorbed = true
    @absorbingMob = mob
    @toScale = 0

  remove: ->
    @removed = true

  absorb: (mob) ->
    unless @absorbing
      @toScale = @scale + mob.scale / 2
      @absorbing = true

      mob.once 'absorbed', =>
        @absorbing = false

      mob.absorbedBy @