// Generated by CoffeeScript 1.3.3
var GameScene, _base, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if ((_ref = window.LD24) == null) {
  window.LD24 = {};
}

if ((_ref1 = (_base = window.LD24).Scenes) == null) {
  _base.Scenes = {};
}

window.LD24.Scenes.GameScene = GameScene = (function(_super) {

  __extends(GameScene, _super);

  function GameScene(game, screen, endless) {
    var _this = this;
    this.game = game;
    this.screen = screen;
    this.endless = endless != null ? endless : false;
    this.running = false;
    this.boundaryOffset = 100;
    this.levelNum = 1;
    this.levelsCount = 5;
    this.defaultZoom = 5;
    this.reset();
    $(document).keydown(function(e) {
      switch (e.keyCode) {
        case 189:
          return _this.zoomOut();
        case 187:
          return _this.zoomIn();
      }
    });
  }

  GameScene.prototype.pause = function() {
    var _this = this;
    if (!this.game.paused) {
      this.game.pause();
      this.selectedItem = $('.ingame-menu .active');
      jwerty.key('↓', function() {
        var nextItem;
        nextItem = _this.selectedItem.next();
        if (nextItem.length === 0) {
          nextItem = _this.selectedItem.parent().find('li').first();
        }
        _this.selectedItem.parent().find('li').removeClass('active');
        _this.selectedItem = nextItem;
        return _this.selectedItem.addClass('active');
      });
      jwerty.key('↑', function() {
        var prevItem;
        prevItem = _this.selectedItem.prev();
        if (prevItem.length === 0) {
          prevItem = _this.selectedItem.parent().find('li').last();
        }
        _this.selectedItem.parent().find('li').removeClass('active');
        _this.selectedItem = prevItem;
        return _this.selectedItem.addClass('active');
      });
      jwerty.key('enter', function() {
        if (_this.selectedItem.hasClass('continue')) {
          _this.pause();
        }
        if (_this.selectedItem.hasClass('retry')) {
          _this.unloadLevel();
          _this.game.unpause();
          $('.ingame-menu').fadeOut('slow');
        }
        if (_this.selectedItem.hasClass('quit')) {
          _this.game.loadSplash();
          return $('.ingame-menu').fadeOut('slow');
        }
      });
      return $('.ingame-menu').fadeIn('slow');
    } else {
      this.game.unpause();
      $(document).off('.jwerty');
      this.handlePause();
      this.player.handleKeyboard();
      return $('.ingame-menu').fadeOut('slow');
    }
  };

  GameScene.prototype.handlePause = function() {
    var _this = this;
    return jwerty.key('escape', function() {
      return _this.pause();
    });
  };

  GameScene.prototype.reset = function() {
    var _this = this;
    this.player = new LD24.Mobs.Player(this.game, this, this.screen);
    this.player.x = this.screen.width / 2;
    this.player.y = this.screen.height / 2;
    this.player.scale = this.player.toScale = 0.04;
    this.player.removeAllListeners('absorb');
    this.player.on('absorb', function(scale) {
      var size;
      size = _this.player.spriteW * scale * _this.zoom;
      if (size > _this.screen.width / 4) {
        return _this.zoomOut();
      }
    });
    this.zoom = this.defaultZoom;
    this.toZoom = this.zoom;
    this.scrollX = this.screen.width / 2 * this.zoom - this.screen.width / 2;
    this.toScrollX = this.scrollX;
    this.scrollY = this.screen.height / 2 * this.zoom - this.screen.height / 2;
    this.toScrollY = this.scrollY;
    this.mobs = [this.player];
    this.particles = [];
    if (!this.endless) {
      this.level = new LD24.Levels['Level' + this.levelNum](this.game, this, this.screen);
      this.level.once('win', function() {
        $('.level-progress').fadeOut('slow');
        _this.levelNum++;
        if (_this.levelNum > _this.levelsCount) {
          $('.level-complete').text('Well done!').fadeIn('slow');
          $('.level-complete-detail').text('You have completed all campaign levels.').fadeIn('slow');
          $('div.continue').text('Press [ENTER] to go to the main menu.').fadeIn('slow');
          $(document).off('.jwerty');
          return jwerty.key('enter', function() {
            return _this.game.loadSplash();
          });
        } else {
          $('.level-complete').text('Level complete').fadeIn('slow');
          $(document).off('.jwerty');
          return after(2000, function() {
            return _this.unloadLevel();
          });
        }
      });
    } else {
      this.level = new LD24.Levels.LevelEndless(this.game, this, this.screen);
    }
    this.level.on('lost', function(reason) {
      if (reason == null) {
        reason = 'You have been absorbed by a bigger particle.';
      }
      $('.level-progress').fadeOut('slow');
      $('.level-complete').text('You lost').fadeIn('slow');
      $('.level-complete-detail').text(reason).fadeIn('slow');
      $('div.continue').fadeIn('slow');
      _this.canReset = true;
      return jwerty.key('enter', function() {
        if (_this.canReset) {
          _this.unloadLevel();
          return _this.canReset = false;
        }
      });
    });
    this.generateParticles();
    return this.loadLevel();
  };

  GameScene.prototype.unloadLevel = function() {
    var _this = this;
    this.level.terminate();
    $(document).off('.jwerty');
    $(document).off('keydown');
    $('.level-complete').fadeOut('slow');
    $('.level-complete-detail').fadeOut('slow');
    $('div.continue').fadeOut('slow');
    $('.level-progress .done').css({
      width: '0'
    });
    return $('canvas').fadeOut('slow', function() {
      _this.reset();
      return _this.running = false;
    });
  };

  GameScene.prototype.loadLevel = function() {
    var _this = this;
    $('.level-complete').text(this.level.name);
    $('.level-complete-detail').text(this.level.subname);
    $('.level-complete').fadeIn('slow');
    return $('.level-complete-detail').fadeIn('slow', function() {
      return after(2000, function() {
        $('.level-complete').fadeOut('slow');
        return $('.level-complete-detail').fadeOut('slow', function() {
          _this.running = true;
          _this.handlePause();
          $('canvas').fadeIn('slow');
          return $('.level-progress').fadeIn('slow');
        });
      });
    });
  };

  GameScene.prototype.zoomOut = function() {
    this.toZoom = Math.max(1, this.toZoom - 1);
    this.toScrollX = this.scrollX / this.zoom * this.toZoom;
    return this.toScrollY = this.scrollY / this.zoom * this.toZoom;
  };

  GameScene.prototype.zoomIn = function() {
    this.toZoom = Math.min(5, this.toZoom + 1);
    this.toScrollX = this.scrollX / this.zoom * this.toZoom;
    return this.toScrollY = this.scrollY / this.zoom * this.toZoom;
  };

  GameScene.prototype.generateParticles = function() {
    var i, particle, _i, _results;
    _results = [];
    for (i = _i = 0; _i < 500; i = ++_i) {
      particle = new LD24.Particle(this.game, this, this.screen);
      particle.x = Math.random() * this.screen.width;
      particle.y = Math.random() * this.screen.height;
      particle.scrollX = this.scrollX;
      particle.scrollY = this.scrollY;
      particle.speedX = particle.toSpeedX = Math.random() * 0.05;
      if (Math.round(Math.random()) === 0) {
        particle.speedX *= -1;
      }
      particle.speedY = particle.toSpeedY = Math.random() * 0.05;
      if (Math.round(Math.random()) === 0) {
        particle.speedY *= -1;
      }
      _results.push(this.particles.push(particle));
    }
    return _results;
  };

  GameScene.prototype.tick = function() {
    var dist, distX, distY, mob, mobRadius, otherMob, otherMobRadius, particle, _i, _j, _len, _len1, _ref2, _ref3, _results;
    if (!this.running) {
      return;
    }
    this.zoom += (this.toZoom - this.zoom) / 10;
    this.scrollX += (this.toScrollX - this.scrollX) / 10;
    this.scrollY += (this.toScrollY - this.scrollY) / 10;
    _ref2 = this.particles;
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      particle = _ref2[_i];
      particle.tick();
    }
    if (this.player.y * this.zoom - this.player.spriteH / 2 * this.zoom * this.player.scale < this.scrollY + this.boundaryOffset) {
      this.toScrollY = this.player.y * this.zoom - this.player.spriteH / 2 * this.zoom * this.player.scale - this.boundaryOffset;
    } else if (this.player.y * this.zoom + this.player.spriteH / 2 * this.zoom * this.player.scale > this.scrollY + this.screen.height - this.boundaryOffset) {
      this.toScrollY = this.player.y * this.zoom - this.screen.height + this.player.spriteH / 2 * this.zoom * this.player.scale + this.boundaryOffset;
    }
    if (this.player.x * this.zoom - this.player.spriteW / 2 * this.zoom * this.player.scale < this.scrollX + this.boundaryOffset) {
      this.toScrollX = this.player.x * this.zoom - this.player.spriteW / 2 * this.zoom * this.player.scale - this.boundaryOffset;
    } else if (this.player.x * this.zoom + this.player.spriteW / 2 * this.zoom * this.player.scale > this.scrollX + this.screen.width - this.boundaryOffset) {
      this.toScrollX = this.player.x * this.zoom - this.screen.width + this.player.spriteW / 2 * this.zoom * this.player.scale + this.boundaryOffset;
    }
    this.toScrollX = Math.min(this.toScrollX, this.screen.width * this.zoom - this.screen.width);
    this.toScrollX = Math.max(this.toScrollX, 0);
    this.toScrollY = Math.min(this.toScrollY, this.screen.height * this.zoom - this.screen.height);
    this.toScrollY = Math.max(this.toScrollY, 0);
    _ref3 = this.mobs;
    _results = [];
    for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
      mob = _ref3[_j];
      if (mob.removed) {
        this.mobs = _.without(this.mobs, mob);
      } else {
        mob.tick();
      }
      _results.push((function() {
        var _k, _len2, _ref4, _results1;
        _ref4 = this.mobs;
        _results1 = [];
        for (_k = 0, _len2 = _ref4.length; _k < _len2; _k++) {
          otherMob = _ref4[_k];
          if (mob.intersects(otherMob) && otherMob !== mob && !otherMob.absorbed) {
            mob.absorb(otherMob);
          }
          if (otherMob !== mob && !otherMob.absorbed && mob.attraction > 0 && !(otherMob instanceof LD24.Mobs.PowerUp) && !(otherMob instanceof LD24.Mobs.Bad)) {
            mobRadius = mob.spriteW / 2 * mob.scale;
            otherMobRadius = otherMob.spriteW / 2 * otherMob.scale;
            distX = mob.x - otherMob.x;
            distY = mob.y - otherMob.y;
            dist = Math.sqrt(Math.pow(Math.abs(distX), 2) + Math.pow(Math.abs(distY), 2)) - mobRadius - otherMobRadius;
            if (dist < 100) {
              otherMob.speedX = distX / 50;
              _results1.push(otherMob.speedY = distY / 50);
            } else {
              _results1.push(void 0);
            }
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
    var arrowRotation, arrowX, arrowY, distX, distY, distanceMax, distanceMin, mob, particle, spriteY, _i, _j, _len, _len1, _ref2, _ref3, _results;
    if (!this.running) {
      return;
    }
    this.renderBackground();
    _ref2 = this.particles;
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      particle = _ref2[_i];
      if (particle.x * this.zoom - this.scrollX < this.screen.width && particle.x * this.zoom - this.scrollX + particle.spriteW * particle.scale * this.zoom > 0 && particle.y * this.zoom - this.scrollY + particle.spriteH * particle.scale * this.zoom > 0 && particle.y * this.zoom - this.scrollY < this.screen.height) {
        particle.render();
      }
    }
    _ref3 = this.mobs;
    _results = [];
    for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
      mob = _ref3[_j];
      if (mob.x * this.zoom - (mob.spriteW * mob.scale * this.zoom) / 2 < this.scrollX + this.screen.width && mob.x * this.zoom + (mob.spriteW * mob.scale * this.zoom) / 2 > this.scrollX && mob.y * this.zoom + (mob.spriteH * mob.scale * this.zoom) / 2 > this.scrollY && mob.y * this.zoom - (mob.spriteH * mob.scale * this.zoom) / 2 < this.scrollY + this.screen.height) {
        mob.render();
      }
      if (mob instanceof LD24.Mobs.Bad || mob instanceof LD24.Mobs.PowerUp) {
        distX = Math.abs(mob.x - (this.scrollX + this.screen.width / 2) / this.zoom);
        distY = Math.abs(mob.y - (this.scrollY + this.screen.height / 2) / this.zoom);
        distanceMin = distX < this.screen.width / 2 / this.zoom + mob.spriteW * mob.scale && distY < this.screen.height / 2 / this.zoom + mob.spriteW * mob.scale;
        distanceMax = distX < this.screen.width / this.zoom + mob.spriteW * mob.scale && distY < this.screen.height / this.zoom + mob.spriteW * mob.scale;
        if (!distanceMin && distanceMax) {
          arrowX = (mob.x * this.zoom) - this.scrollX;
          arrowX = Math.max(arrowX, 0);
          arrowX = Math.min(arrowX, this.screen.width - 38);
          arrowY = (mob.y * this.zoom) - this.scrollY;
          arrowY = Math.max(arrowY, 0);
          arrowY = Math.min(arrowY, this.screen.height - 25);
          distX = (mob.x * this.zoom) - (this.scrollX + this.screen.width / 2);
          distY = (mob.y * this.zoom) - (this.scrollY + this.screen.height / 2);
          arrowRotation = Math.atan2(distY, distX);
          if (mob instanceof LD24.Mobs.Bad) {
            spriteY = 32 + 25;
          } else if (mob instanceof LD24.Mobs.PowerUpSpeed) {
            spriteY = 32;
          } else if (mob instanceof LD24.Mobs.PowerUpAttraction) {
            spriteY = 32 + 25 * 2;
          }
          _results.push(this.screen.render(768, spriteY, 38, 25, arrowX, arrowY, null, null, arrowRotation));
        } else {
          _results.push(void 0);
        }
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
    this.screen.context.drawImage(this.screen.background, this.scrollX / this.zoom, this.scrollY / this.zoom, this.screen.width / this.zoom, this.screen.height / this.zoom, 0, 0, this.screen.width, this.screen.height);
    return this.screen.restore();
  };

  GameScene.prototype.terminate = function(callback) {
    var _this = this;
    $('.level-progress, .level-complete, .level-complete-detail, div.continue').fadeOut('slow');
    this.game.hideInfoBox();
    $(document).off('.jwerty');
    $(document).off('keydown');
    return $('canvas').fadeOut('slow', function() {
      return typeof callback === "function" ? callback() : void 0;
    });
  };

  return GameScene;

})(EventEmitter);
