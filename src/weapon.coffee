"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    class BasicWeapon
      damage: 10
      # How many HP will the damage vary
      variation: 2
      #An interger or percentage of the chance to hit.
      accuracy: 800 / 1000
      name: "BasicWeapon"
      constructor: (@game, @ship) ->
      fire: (target) ->
