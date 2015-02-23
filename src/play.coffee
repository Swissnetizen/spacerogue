"use strict"
define ["Phaser", "Ship"], (Phaser, ship) ->
  exports = {}
  exports.PlayState = class PlayState extends Phaser.State
    create: ->
      @ship = new ship.BaseShip(@game, 10, 10, "shuttle")
      game.add.existing @ship
    update: ->
  exports
