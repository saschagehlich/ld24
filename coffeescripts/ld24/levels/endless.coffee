window.LD24 ?= {}
window.LD24.Levels ?= {}
window.LD24.Levels.LevelEndless = class LevelEndless extends LD24.Level
  subname: 'Endless Game Mode'
  constructor: (@game, @scene, @screen, level) ->
    super @game, @scene, @screen

    @name = 'Level ' + level
    
    @levelNumDisplayer.text @name