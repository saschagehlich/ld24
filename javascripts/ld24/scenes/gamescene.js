// Generated by CoffeeScript 1.3.3
var GameScene, _base, _ref, _ref1;

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

if ((_ref1 = (_base = window.LD24).Scenes) == null) {
  _base.Scenes = {};
}

window.LD24.Scenes.GameScene = GameScene = (function() {

  function GameScene(game, screen) {
    var _this = this;
    this.game = game;
    this.screen = screen;
    this.player = new LD24.Mobs.Player(this.game, this, this.screen);
    this.player.x = this.screen.width / 2;
    this.player.y = this.screen.height / 2;
    this.player.scale = 0.04;
    this.player.toScale = this.player.scale;
    this.zoom = 5;
    this.toZoom = this.zoom;
    this.scrollX = this.screen.width / 2 * this.zoom - this.screen.width / 2;
    this.toScrollX = this.scrollX;
    this.scrollY = this.screen.height / 2 * this.zoom - this.screen.height / 2;
    this.toScrollY = this.scrollY;
    this.mobs = [this.player];
    this.generateMobs();
    $(document).keydown(function(e) {
      switch (e.keyCode) {
        case 189:
          _this.toZoom = Math.max(1, _this.toZoom - 1);
          _this.toScrollX = _this.screen.width / 2 * _this.toZoom - _this.screen.width / 2;
          return _this.toScrollY = _this.screen.height / 2 * _this.toZoom - _this.screen.height / 2;
        case 187:
          _this.toZoom = Math.min(5, _this.toZoom + 1);
          _this.toScrollX = _this.screen.width / 2 * _this.toZoom - _this.screen.width / 2;
          return _this.toScrollY = _this.screen.height / 2 * _this.toZoom - _this.screen.height / 2;
      }
    });
  }

  GameScene.prototype.generateMobs = function() {
    var i, mob, _i, _results;
    _results = [];
    for (i = _i = 0; _i < 30; i = ++_i) {
      mob = new LD24.Mobs.Mote(this.game, this, this.screen);
      mob.x = Math.random() * this.screen.width;
      mob.y = Math.random() * this.screen.height;
      mob.speedX = mob.toSpeedX = Math.random() * mob.maxSpeed;
      mob.speedY = mob.toSpeedY = Math.random() * mob.maxSpeed;
      _results.push(this.mobs.push(mob));
    }
    return _results;
  };

  GameScene.prototype.tick = function() {
    var mob, otherMob, _i, _len, _ref2, _results;
    this.zoom += (this.toZoom - this.zoom) / 10;
    this.scrollX += (this.toScrollX - this.scrollX) / 10;
    this.scrollY += (this.toScrollY - this.scrollY) / 10;
    _ref2 = this.mobs;
    _results = [];
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      mob = _ref2[_i];
      if (mob.removed) {
        this.mobs = _.without(this.mobs, mob);
      } else {
        mob.tick();
      }
      _results.push((function() {
        var _j, _len1, _ref3, _results1;
        _ref3 = this.mobs;
        _results1 = [];
        for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
          otherMob = _ref3[_j];
          if (mob.intersects(otherMob) && mob.scale > otherMob.scale && otherMob !== mob && !otherMob.absorbed) {
            _results1.push(mob.absorb(otherMob));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      }).call(this));
    }
    return _results;
  };

  GameScene.prototype.render = function() {
    var mob, _i, _len, _ref2, _results;
    this.renderBackground();
    _ref2 = this.mobs;
    _results = [];
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      mob = _ref2[_i];
      if (mob.x * this.zoom - (mob.spriteW * mob.scale * this.zoom) / 2 < this.screen.width * this.zoom - this.scrollX && mob.x * this.zoom + (mob.spriteW * mob.scale * this.zoom) / 2 > this.screen.width * this.zoom - this.scrollX - this.screen.width && mob.y * this.zoom + (mob.spriteH * mob.scale * this.zoom) / 2 > this.screen.height * this.zoom - this.scrollY - this.screen.height && mob.y * this.zoom - (mob.spriteH * mob.scale * this.zoom) / 2 < this.screen.height * this.zoom - this.scrollY) {
        _results.push(mob.render());
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  GameScene.prototype.renderBackground = function() {
    this.screen.save();
    this.screen.context.fillStyle = 'rgb(10,14,30)';
    this.screen.context.fillRect(0, 0, this.screen.width, this.screen.height);
    return this.screen.restore();
  };

  return GameScene;

})();
