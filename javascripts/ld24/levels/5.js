// Generated by CoffeeScript 1.3.3
var Level5, _base, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

if ((_ref1 = (_base = window.LD24).Levels) == null) {
  _base.Levels = {};
}

window.LD24.Levels.Level5 = Level5 = (function(_super) {

  __extends(Level5, _super);

  Level5.prototype.name = 'Level 5';

  Level5.prototype.subname = 'Quite Attractive';

  function Level5(game, scene, screen) {
    var i, mob, scale, _i, _j, _k, _l, _len, _m, _ref2;
    this.game = game;
    this.scene = scene;
    this.screen = screen;
    Level5.__super__.constructor.call(this, this.game, this.scene, this.screen);
    this.levelNumDisplayer.text(this.name);
    this.game.showInfoBox('Blue power ups are attraction power ups. They let your dust particle attract other particles for some time.');
    for (i = _i = 0; _i < 30; i = ++_i) {
      scale = 0.01 + Math.random() * 0.03;
      this.addNormalMobs(1, scale);
    }
    for (i = _j = 0; _j < 30; i = ++_j) {
      scale = 0.01 + Math.random() * 0.1;
      this.addNormalMobs(1, scale);
    }
    for (i = _k = 0; _k < 5; i = ++_k) {
      scale = 0.01 + Math.random() * 0.1;
      this.addBadMobs(1, scale);
    }
    for (i = _l = 0; _l < 3; i = ++_l) {
      scale = 0.03 + Math.random() * 0.1;
      this.addAttractionPowerUps(1, scale);
    }
    this.goalScale = 0;
    _ref2 = this.scene.mobs;
    for (_m = 0, _len = _ref2.length; _m < _len; _m++) {
      mob = _ref2[_m];
      this.goalScale += mob.scale / 5;
    }
  }

  return Level5;

})(LD24.Level);
