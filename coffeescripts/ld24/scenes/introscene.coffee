window.LD24 ?= {}
window.LD24.Scenes ?= {}
window.LD24.Scenes.IntroScene = class IntroScene extends EventEmitter
  constructor: (@game, @screen) ->
    @intro = $('.intro')

    after 1000, =>
      @intro.find('.filsh-media').fadeIn 'slow', =>
        @intro.find('.filsh-media .logo').animate width: 130, opacity: 0, left: '+=5', top: '+=5', "fast", =>
          @intro.find('.filsh-media .mob').animate width: 142, opacity: 1, left: '-=5', top: '-=5', "fast", =>
            @intro.find('.filsh-media .text').fadeOut 'fast', =>
              @intro.find('.filsh-media .mob').animate left: $('.intro').width(), opacity: 0, 'slow', =>

                after 500, =>
                  @intro.find('.ld').fadeIn 'slow', =>
                    after 1500, =>
                      @intro.find('.ld').fadeOut 'slow', =>
                        @game.loadSplash()

  terminate: (callback) ->
    $('.intro').fadeOut 'slow', =>
      callback?()

  tick: ->
  render: ->