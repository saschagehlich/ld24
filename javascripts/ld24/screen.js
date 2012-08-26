// Generated by CoffeeScript 1.3.3
var Screen, _ref;

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

window.LD24.Screen = Screen = (function() {

  function Screen(canvas) {
    this.canvas = canvas;
    this.context = this.canvas.get(0).getContext('2d');
    this.width = this.canvas.width();
    this.height = this.canvas.height();
    this.canvas.get(0).width = this.width;
    this.canvas.get(0).height = this.height;
    this.sprites = new Image();
    this.sprites.src = 'assets/images/sprites.png';
    this.background = new Image();
    this.background.src = 'assets/images/background.png';
  }

  Screen.prototype.clear = function() {
    return this.context.fillRect(0, 0, this.width, this.height);
  };

  Screen.prototype.render = function(sx, sy, sw, sh, dx, dy, dw, dh, rotation) {
    if (rotation == null) {
      rotation = null;
    }
    if (dw == null) {
      dw = sw;
    }
    if (dh == null) {
      dh = sh;
    }
    this.save();
    if (rotation != null) {
      this.context.translate(dx + dw / 2, dy + dh / 2);
      this.context.rotate(rotation);
      this.context.drawImage(this.sprites, sx, sy, sw, sh, Math.round(-dw / 2), -dh / 2, dw, dh);
    } else {
      this.context.drawImage(this.sprites, sx, sy, sw, sh, dx, dy, dw, dh);
    }
    return this.restore();
  };

  Screen.prototype.save = function() {
    return this.context.save();
  };

  Screen.prototype.restore = function() {
    return this.context.restore();
  };

  return Screen;

})();
