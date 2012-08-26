// Generated by CoffeeScript 1.3.3
var Game, _ref;

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

window.LD24.Game = Game = (function() {

  Game.prototype.framesPerSecond = 60;

  Game.prototype.version = "0.3";

  function Game(canvas) {
    var _this = this;
    this.canvas = canvas;
    this.screen = new LD24.Screen(this.canvas);
    if ($.cookie('abs_intro_seen') !== '1') {
      this.scene = new LD24.Scenes.IntroScene(this, this.screen);
    } else {
      this.scene = new LD24.Scenes.SplashScene(this, this.screen);
    }
    this.sounds = new LD24.Sounds(this);
    this.sounds.on('loaded', function() {
      return _this.sounds.playSoundtrack();
    });
    this.setupTickLoop();
    this.setupRenderLoop();
    $('.version').text(this.version);
    this.paused = false;
    $(document).keydown(function(e) {
      if (e.keyCode === 80) {
        if (!_this.paused) {
          return _this.pause();
        } else {
          return _this.unpause();
        }
      }
    });
  }

  Game.prototype.showInfoBox = function(message) {
    var _this = this;
    $('.info-box .text').text(message);
    $('.info-box').css({
      marginTop: -5,
      opacity: 0,
      display: 'block'
    });
    $('.info-box').animate({
      marginTop: 0,
      opacity: 0.8
    }, 'slow');
    return $('.info-box .close').click(function() {
      return _this.hideInfoBox();
    });
  };

  Game.prototype.hideInfoBox = function() {
    return $('.info-box').fadeOut('fast');
  };

  Game.prototype.loadCampaign = function() {
    var _this = this;
    return this.scene.terminate(function() {
      return _this.scene = new LD24.Scenes.GameScene(_this, _this.screen);
    });
  };

  Game.prototype.loadEndless = function() {
    var _this = this;
    return this.scene.terminate(function() {
      return _this.scene = new LD24.Scenes.GameScene(_this, _this.screen, true);
    });
  };

  Game.prototype.loadSplash = function() {
    var _this = this;
    return this.scene.terminate(function() {
      return _this.scene = new LD24.Scenes.SplashScene(_this, _this.screen);
    });
  };

  Game.prototype.setupTickLoop = function() {
    var _this = this;
    return this.tickLoop = every(1000 / this.framesPerSecond, function() {
      return _this.tick();
    });
  };

  Game.prototype.setupRenderLoop = function() {
    var _this = this;
    return this.renderLoop = every(1000 / this.framesPerSecond, function() {
      return _this.render();
    });
  };

  Game.prototype.tick = function() {
    return this.scene.tick();
  };

  Game.prototype.render = function() {
    this.screen.clear();
    return this.scene.render();
  };

  Game.prototype.pause = function() {
    if (this.paused) {
      return;
    }
    this.paused = true;
    clearInterval(this.tickLoop);
    return clearInterval(this.renderLoop);
  };

  Game.prototype.unpause = function() {
    if (!this.paused) {
      return;
    }
    this.paused = false;
    this.setupTickLoop();
    return this.setupRenderLoop();
  };

  Game.prototype.debug = function(msg) {
    return $('.debug').show().text(msg);
  };

  return Game;

})();
