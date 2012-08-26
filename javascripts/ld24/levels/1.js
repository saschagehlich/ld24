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

  Level1.prototype.name = 'Level 1';

  Level1.prototype.subname = 'The Beginning';

  function Level1(game, scene, screen) {
    var i, mob, scale, _i, _j, _len, _ref2;
    this.game = game;
    this.scene = scene;
    this.screen = screen;
    Level1.__super__.constructor.call(this, this.game, this.scene, this.screen);
    this.levelNumDisplayer.text('Level 1');
    this.game.showInfoBox('Use the arrow keys or WASD on your keyboard to move your dust particle and to absorb smaller dust particles.');
    for (i = _i = 0; _i < 60; i = ++_i) {
      scale = 0.01 + Math.random() * 0.03;
      this.addNormalMobs(1, scale);
    }
    this.goalScale = 0;
    _ref2 = this.scene.mobs;
    for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
      mob = _ref2[_j];
      this.goalScale += mob.scale / 5;
    }
  }

  return Level1;

})(LD24.Level);
