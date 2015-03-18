"use strict"
define ["Phaser", "_"], (Phaser) ->
  exports =
    BasicWeapon: class BasicWeapon
      damage: 20
      # How many HP will the damage vary
      variation: 2
      #An interger or percentage of the chance to hit.
      accuracy: 800 / 1000
      name: "BasicWeapon"
      maxDistance: 200
      timeActive: 1000
      constructor: (@game, @fleet) ->
        console.dir this
        @beam = game.add.graphics 0, 0
        @direction = new Phaser.Line()
      # Fire
      fire: (ship, target) ->
        @direction.fromSprite ship, target
        @ship = ship
        @target = target
        # Go over line to find intersections
        @fail = no
        _.each (@direction.coordinatesOnLine 5), (n) =>
            # Checks if any of the sprites are other than the ship OR target
           _.each (@game.physics.p2.hitTest {x: n[0], y: n[1]}), (n) =>
                @fail = yes unless n.id == @ship.body.id || n.id == @target.body.id
        console.log @fail
        return if @fail
        # Draw attack laser thing if TRUE
        @draw ship, target
      draw: (from, to) ->
        console.log "(HELLO)"
        @beam.lineStyle 2, 0xFF0000, 1
        @beam.moveTo from.x, from.y
        @beam.lineTo to.x, to.y
        # Do damage in two seperate strokes
        game.timer.add @timeActive / 2, =>
          @target.damage @damage / 2
        game.timer.add @timeActive, =>
          @beam.clear()
          @target.damage @damage / 2

