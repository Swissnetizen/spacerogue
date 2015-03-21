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
      timeActive: 3000
      rechargeTime: 2000
      constructor: (@game, @fleet) ->
        console.dir this
        @beam = game.add.graphics 0, 0
        @direction = new Phaser.Line()
      # set Target
      setTarget: (ship, target) ->
        console.log "SETTING TARGETZ"
        @ship = ship
        @target = target
        # Go over line to find intersections
        # Draw attack laser thing if TRUE
        @fire()
      fire: ->
        @direction.fromSprite @ship, @target
        # Can we get the target ?
        unless @canFire()
          #Check laterz
          console.log "CHECK LATERZ"
          @game.timer.add 100, @fire, this
        # We can get the target
        # Draw laser beamz (in a timer thing cos otherwise it would draw when paused)
        @game.timer.add 1, @draw, this
        # Start the firing loop
        @game.timer.add 10, @whenFiring, this
        console.log "FIREZ"
      canFire: ->
        @fail = no
        return yes if @direction.length > @maxDistence
        _.each (@direction.coordinatesOnLine 5), (n) =>
            # Checks if any of the sprites are other than the ship OR target
           _.each (@game.physics.p2.hitTest {x: n[0], y: n[1]}), (n) =>
                @fail = yes unless n.id == @ship.body.id || n.id == @target.body.id
        return !@fail
      draw: (from=@ship, to=@target) ->
        @beam.lineStyle 2, 0xFF0000, 1
        @beam.moveTo from.x, from.y
        @beam.lineTo to.x, to.y
        # Do damage in two seperate strokes
        @beenActive = 0

      # Checks stuff when firing
      whenFiring: =>
        @beenActive += 10
        if @beenActive > @timeActive || !@canFire()
          @beam.clear()
          @beginRecharge()
          return
        #Is the the target still in the beam?
        pointingTo = @game.physics.p2.hitTest @direction.end, [@target], 2, yes
        console.log pointingTo
        unless pointingTo.length == 1 && pointingTo[0].parent == @target.body
          console.log "CLEARING"
          game.timer.add 100, =>
            @beam.clear()
            @beginRecharge()
          return
        # Damage
        @target.damage @damage * (1 / @timeActive)
        game.timer.add 10, @whenFiring
      beginRecharge: ->
        game.timer.add @rechargeTime, @fire, this
