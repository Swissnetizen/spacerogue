define ["Phaser", "PlayerControl"], (Phaser) ->
  exports = {}
  exports.BaseShip = class BaseShip extends Phaser.Sprite
    #Properties of a ship
    maxHardPoints: 2
    #Will result in death when this reaches 0
    health: 100
    maxCargo: 4,
    maxUtilPoints: 3
    maxCrew: 6
    minCrew: 3
    constructor: (game, x, y, key, frame) ->
      @hardPoints = []
      @UtilPoints = []
      @Crew = []
      super(game, x, y, key, frame)

  #Return Exports
  exports
