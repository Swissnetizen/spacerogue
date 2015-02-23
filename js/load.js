"use strict";
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(["Phaser"], function(Phaser) {
  var LoadState, exports;
  exports = {};
  exports.LoadState = LoadState = (function(superClass) {
    extend(LoadState, superClass);

    function LoadState() {
      return LoadState.__super__.constructor.apply(this, arguments);
    }

    LoadState.prototype.preload = function() {
      var loadingLabel, progressBar;
      loadingLabel = this.game.add.text(game.world.centerX, 150, "loading...", {
        font: "30px Arial",
        fill: "#ffffff"
      });
      loadingLabel.anchor.setTo(0.5, 0.5);
      progressBar = this.game.add.sprite(game.world.centerX, 200, "progressBar");
      progressBar.anchor.setTo(0.5, 0.5);
      this.game.load.setPreloadSprite(progressBar);
      this.game.load.image("shuttle", "assets/shuttle.png");
      this.game.load.spritesheet("mute", "assets/muteButton.png", 28, 22);
    };

    LoadState.prototype.create = function() {
      this.game.state.start("menu");
    };

    return LoadState;

  })(Phaser.State);
  return exports;
});
