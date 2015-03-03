"use strict"
define ["Phaser", "Ship", "PlayerControl"], (Phaser, ship, playerControl) ->
  exports = {}
  exports.PlayState = class PlayState extends Phaser.State
    create: ->
      versionLabel = @game.add.text(
        @game.world.width-70
        5
        "v#{game.global.version}",
          font: "25px pixelated"
          fill: "#ffffff")
      game.input.keyboard.addKey(Phaser.Keyboard.ESC).onDown.add @end, this
      game.physics.p2.defaultRestitution = 0.8;
      @ship1 = new ship.BaseShip(@game, 250, 175, "shuttle")
      @ship2 = new ship.BaseShip(@game, 400, 175, "shuttle")
      game.add.existing @ship1
      game.add.existing @ship2
      @playerUi = new playerControl.PlayerShipMenu(@game);
      @playerUi.enableControlOnSprite @ship1
      @playerUi.enableControlOnSprite @ship2
    end: ->
      game.state.start "menu"
    update: ->
  exports
