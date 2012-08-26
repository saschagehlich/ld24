// Generated by CoffeeScript 1.3.3
var Level6, _base, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

if ((_ref1 = (_base = window.LD24).Levels) == null) {
  _base.Levels = {};
}

window.LD24.Levels.Level6 = Level6 = (function(_super) {

  __extends(Level6, _super);

  Level6.prototype.name = 'Level 6';

  Level6.prototype.subname = 'Protect me!';

  function Level6(game, scene, screen) {
    var i, mob, powerupX, powerupY, scale, _i, _j, _k, _l, _len, _m, _ref2;
    this.game = game;
    this.scene = scene;
    this.screen = screen;
    Level6.__super__.constructor.call(this, this.game, this.scene, this.screen);
    this.levelNumDisplayer.text(this.name);
    this.game.showInfoBox('Yellow power ups are protection power ups. They give you immunity to absorption for some time.');
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
    for (i = _l = 0; _l < 2; i = ++_l) {
      scale = 0.03 + Math.random() * 0.1;
      this.addAttractionPowerUps(1, scale);
    }
    scale = 0.03 + Math.random() * 0.1;
    powerupX = this.scene.scrollX / this.scene.zoom + Math.random() * this.screen.width / this.scene.zoom;
    powerupY = this.scene.scrollY / this.scene.zoom + Math.random() * this.screen.height / this.scene.zoom;
    this.addProtectionPowerUps(1, scale, powerupX, powerupY);
    this.goalScale = 0;
    _ref2 = this.scene.mobs;
    for (_m = 0, _len = _ref2.length; _m < _len; _m++) {
      mob = _ref2[_m];
      this.goalScale += mob.scale / 5;
    }
  }

  return Level6;

})(LD24.Level);
