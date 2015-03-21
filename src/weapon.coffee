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
        @beginRecharge off
      # set Target
      setTarget: (ship, target) ->
        console.log "SETTING TARGETZ"
        @ship = ship
        @target = target
        # Go over line to find intersections
        # Draw attack laser thing if TRUE
        @fire()
      fire: ->
        # Need to have target and ship
        return unless @target and @ship
        @direction.fromSprite @ship, @target
        # Can we get the target ?
        unless @canFire()
          #Check laterz
          console.log "CHECK LATERZ"
          @game.timer.add 100, @fire, this
        # We can get the target
        # Draw laser beamz (in a timer thing cos otherwise it would draw when paused)
        @game.timer.add 100, @draw, this
        # Start the firing loop
        @game.timer.add 100, @whenFiring, this
        console.log "FIREZ"
      canFire: ->
        @fail = no
        return yes if @direction.length > @maxDistence
        # THEY MUST BOTH
        return no unless @target and @ship
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

      # Checks stuff when firing
      whenFiring: =>
        @beenActive += 10
        return unless @ship and @target
        if @beenActive > @timeActive || !@canFire()
          @beginRecharge()
          return
        #Is the the target still in the beam?
        pointingTo = @game.physics.p2.hitTest @direction.end, [@target], 2, yes
        unless pointingTo.length == 1 && pointingTo[0].parent == @target.body
          console.log "CLEARING"
          game.timer.add 100, =>
            @beam.clear()
            @fire()
          return
        # Damage
        @target.damage @damage / (@timeActive * .1)
        @target = null if @target.health <= 0
        game.timer.add 10, @whenFiring
      beginRecharge: (fireWhenDone=on) ->
        #Cannot recharge while active
        @beam.clear()
        game.timer.add @rechargeTime, @fire, this if fireWhenDone
        @beenActive = 0
