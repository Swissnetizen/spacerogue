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
      # Centi Seconds
      timeActive: 300
      @
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
        return unless @canFire()
        # Draw attack laser thing if TRUE
        @game.timer.add 1, =>
          @draw ship, target
      canFire: ->
        @fail = no
        return yes if @direction.length > @maxDistence
        _.each (@direction.coordinatesOnLine 5), (n) =>
            # Checks if any of the sprites are other than the ship OR target
           _.each (@game.physics.p2.hitTest {x: n[0], y: n[1]}), (n) =>
                @fail = yes unless n.id == @ship.body.id || n.id == @target.body.id
        return !@fail
      draw: (from, to) ->
        @beam.lineStyle 2, 0xFF0000, 1
        @beam.moveTo from.x, from.y
        @beam.lineTo to.x, to.y
        # Do damage in two seperate strokes
        @beenActive = 0
        game.timer.add 10, @whenFiring
      whenFiring: =>
        @beenActive += 1
        if @beenActive == @timeActive || !@canFire()
          @beam.clear()
          @beginRecharge()
        #Is the the target still in the beam?
        unless @game.physics.p2.hitTest @direction.end, [@target], 2, true
          game.timer.add 100, =>
            @beam.clear()
            @beginRecharge()
          return
        # Damage
        @target.damage @damage * (1 / @timeActive)
        game.timer.add 10, @whenFiring
      beginRecharge: =>
