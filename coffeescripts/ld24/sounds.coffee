window.LD24 ?= {}
window.LD24.Sounds = class Sounds
  constructor: (@game) ->
    soundManager.setup
      debugMode: false
      url: 'assets/swf/'
      onready: =>
        @loadSounds()

  loadSounds: ->
    @sounds =
      absorb:
        files: ['absorb_1', 'absorb_2', 'absorb_3']
        sounds: []

    for name, options of @sounds
      for file in options.files
        sound = soundManager.createSound
          id: file,
          url: ['assets/audio/' + file + '.mp3', 'assets/audio/' + file + '.aac', 'assets/audio/' + file + '.ogg']
          autoLoad: true
          autoPlay: false
        options.sounds.push sound

  playSound: (id) ->
    sounds = @sounds[id].sounds
    _.shuffle(sounds)[0].play()