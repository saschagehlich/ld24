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

    @powerupAttraction = false
    @powerupAttractionEndTick = 0
    @attraction = 0

    @tickCount = 0

    @opacity = 0.9

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

    # boundaries!
    if @x + @spriteW * @scale / 2 >= @screen.width and @speedX > 0
      @speedX *= -1
      @toSpeedX *= -1
    else if @x - @spriteW * @scale / 2 <= 0 and @speedX < 0
      @speedX *= -1
      @toSpeedX *= -1

    if @y + @spriteH * @scale / 2 >= @screen.height and @speedY > 0
      @speedY *= -1
      @toSpeedY *= -1
    else if @y - @spriteH * @scale / 2 <= 0 and @speedY < 0
      @speedY *= -1
      @toSpeedY *= -1

    @scale += (@toScale - @scale) / 10
    if @scale < 0.01
      @emit "absorbed", @absorbingMob
      @remove()

    @rotation += @speedRotation

    @tickCount++

  render: ->
    finalW = @spriteW * @scale * @scene.zoom
    finalH = @spriteH * @scale * @scene.zoom
    finalX = (@x * @scene.zoom - finalW / 2) - @scene.scrollX
    finalY = (@y * @scene.zoom - finalH / 2) - @scene.scrollY

    @screen.save()
    if @opacity isnt 1
      @screen.context.globalAlpha = @opacity

    @screen.render 0, 0, 256, 256, finalX, finalY, finalW, finalH
    @screen.render 256, 0, 256, 256, finalX - @speedX * 2 * @scene.zoom, finalY - @speedY * 2 * @scene.zoom, finalW, finalH, @rotation * (Math.PI/180)

    @screen.restore()

  intersects: (mob) ->
    # circular intersection
    dx = Math.abs(@x - mob.x)
    dy = Math.abs(@y - mob.y)
    d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))

    if d > mob.spriteW * mob.scale / 2 + @spriteW * @scale / 2
      return false

    return true

  absorbedBy: (mob) ->
    @absorbed = true
    @absorbingMob = mob
    @toScale = 0

  canBeAbsorbedBy: (mob) ->
    if @scale > mob.scale
      return false
    return true

  remove: ->
    @removed = true

  absorb: (mob) ->
    if not @absorbing and mob.canBeAbsorbedBy(@) and !@absorbed
      @toScale = @scale + mob.scale / 2
      @absorbing = true

      mob.once 'absorbed', =>
        @absorbing = false

      mob.absorbedBy @