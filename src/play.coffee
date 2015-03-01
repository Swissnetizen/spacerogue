"use strict"
define ["Phaser", "Ship", "PlayerControl"], (Phaser, ship, playerControl) ->
  exports = {}
  exports.PlayState = class PlayState extends Phaser.State
    create: ->
      @ship = new ship.BaseShip(@game, 250, 175, "shuttle")
      game.add.existing @ship
      @playerUi = new playerControl.PlayerShipMenu(@game);
      @playerUi.enableControlOnSprite @ship
    update: ->
  exports
