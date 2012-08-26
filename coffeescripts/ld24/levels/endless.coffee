window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.LevelEndless = class LevelEndless extends LD24.Level
  subname: 'Endless Game Mode'
  constructor: (@game, @scene, @screen, level) ->
    super @game, @scene, @screen

    @name = 'Level ' + level
    
    @levelNumDisplayer.text @name

    # Add some mobs
    for i in [0...Math.min(25 + level * 5, 60)]
      scale = 0.01 + Math.random() * Math.min(0.03 * level, 0.1)
      @addNormalMobs 2, scale

    # Add some bad mobs
    if level >= 3
      for i in [0...Math.min(3 + level, 6)]
        scale = 0.02 + Math.random() * Math.min(0.03 * level, 0.1)
        @addBadMobs 1, scale

    # Add attraction powerups
    if level >= 4
      for i in [0...2]
        scale = 0.02 + Math.random() * 0.03
        @addAttractionPowerUps 1, scale

    # Add speed powerups
    if level >= 5
      for i in [0...2]
        scale = 0.02 + Math.random() * 0.03
        @addSpeedPowerUps 1, scale

    # Add protection powerup
    if level >= 6
      for i in [0...1]
        scale = 0.02 + Math.random() * 0.03
        @addProtectionPowerUps 1, scale

    # Calculate goal
    totalScale = 0
    for mob in @scene.mobs
      unless (mob instanceof LD24.Mobs.Bad) or (mob instanceof LD24.Mobs.PowerUp)
        totalScale += mob.scale

    @goalScale = totalScale / 5