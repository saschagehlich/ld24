// Generated by CoffeeScript 1.3.3
var Level1, _base, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

if ((_ref1 = (_base = window.LD24).Levels) == null) {
  _base.Levels = {};
}

window.LD24.Levels.Level1 = Level1 = (function(_super) {

  __extends(Level1, _super);

  function Level1(game, scene, screen) {
    var mob, _i, _len, _ref2,
      _this = this;
    this.game = game;
    this.scene = scene;
    this.screen = screen;
    Level1.__super__.constructor.call(this, this.game, this.scene, this.screen);
    this.levelNumDisplayer.text('Level 1');
    this.addNormalMobs(60);
    this.goalScale = 0;
    _ref2 = this.scene.mobs;
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      mob = _ref2[_i];
      this.goalScale += mob.scale / 5;
    }
    this.scene.player.on('absorb', function(scale) {
      var percentDone;
      percentDone = Math.round(100 / _this.goalScale * scale);
      percentDone = Math.min(percentDone, 100);
      _this.progressDoneDisplayer.stop().animate({
        width: percentDone + '%'
      }, 'fast');
      if (percentDone >= 100) {
        return _this.emit('win');
      }
    });
  }

  return Level1;

})(LD24.Level);
