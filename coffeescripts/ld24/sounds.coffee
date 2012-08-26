window.LD24 ?= {}
window.LD24.Sounds = class Sounds extends EventEmitter
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

    filesLoaded = 0
    filesToLoad = 4
    @soundtrack = soundManager.createSound
      id: 'soundtrack'
      url: ['assets/audio/absorption.mp3', 'assets/audio/absorption.aac', 'assets/audio/absorption.ogg'] 
      autoLoad: true
      autoPlay: false
      onload: =>
        filesLoaded++
        if filesLoaded is filesToLoad
          @emit 'loaded'

      onfinish: =>
        @playSoundtrack()

    for name, options of @sounds
      for file in options.files
        sound = soundManager.createSound
          id: file,
          url: ['assets/audio/' + file + '.mp3', 'assets/audio/' + file + '.aac', 'assets/audio/' + file + '.ogg']
          autoLoad: true
          autoPlay: false
          onload: =>
            filesLoaded++
            if filesLoaded is filesToLoad
              @emit 'loaded'
        options.sounds.push sound

  playSound: (id) ->
    sounds = @sounds[id].sounds
    _.shuffle(sounds)[0].play()

  playSoundtrack: ->
    @soundtrack.play()