"use strict"
define ["Phaser"], (Phaser) ->
  exports = {}
  exports.BaseShip = class BaseShip extends Phaser.Sprite
    #Properties of a ship
    maxHardPoints: 2
    #Will result in death when this reaches 0
    health: 100
    maxCargo: 4,
    maxUtilPoints: 3
    maxCrew: 6
    minCrew: 2
    #Speed in px/s (m/s)
    speed: 125
    constructor: (game, x, y, key, frame) ->
      @hardPoints = []
      @UtilPoints = []
      @Crew = []
      super game, x, y, key, frame
      @game.physics.p2.enable this
      console.dir this

  #Return Exports
  exports
