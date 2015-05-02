"use strict"
define ["Phaser", "_", "weapon"], (Phaser, _, weapon) ->
  exports =
    Basic: class BasicWeapon extends weapon.Base
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
        console.dir 
        @beamGraphic = game.add.graphics 0, 0
        @direction = new Phaser.Line()
        @beginRecharge off
        @targetRandomness = new Phaser.RandomDataGenerator(Date.now())
      # set Target
      setTarget: (ship, target) ->
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
          @game.timer.add 100, @fire, this
        # We can get the target
        # Draw laser beamz (in a timer thing cos otherwise it would draw when paused)
        @game.timer.add 1, @draw, this
        # Start the firing loop
        @game.timer.add 1, @whenFiring, this
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
        # Randomise where beam hits!
        coords = @randomShipCoords to
        @beamGraphic.lineStyle 2, 0xFF0000, 1
        @beamGraphic.moveTo from.x, from.y
        @beamGraphic.lineTo coords.x, coords.y
        # Do damage in two seperate strokes
      randomShipCoords: (ship, trials=0) ->
        h = @ship.height / 2 * 500 / 1000
        w = @ship.width / 2 * 500 / 1000
        x = @targetRandomness.between(-w, w) + ship.x
        y = @targetRandomness.between(-h, h) + ship.y
        #Prevents infinte loop
        test = @game.physics.p2.hitTest {x: x, y: y}
        if trials == 10
          return {x: ship.x, y: ship.y}
        else if test > 1 ||  !test || test[0].parent.sprite != ship
          @randomShipCoords ship, trials + 1
        else
          return {x: x, y: y}
      # Checks stuff when firing
      whenFiring: =>
        @beenActive += 1
        return unless @ship and @target
        if @beenActive > @timeActive || !@canFire()
          @beginRecharge()
          return
        #Is the the target still in the beam?
        pointingTo = @game.physics.p2.hitTest @direction.end, [@target], 2, yes
        unless pointingTo.length == 1 && pointingTo[0].parent == @target.body
          @beenActive += .0001
          game.timer.add .0001, =>
            @beamGraphic.clear()
            @fire()
          return
        # Damage
        @target.damage @damage / (@timeActive * .1)
        @target = null if @target.health <= 0
        game.timer.add 1, @whenFiring
      beginRecharge: (fireWhenDone=on) ->
        #Cannot recharge while active
        @beamGraphic.clear()
        game.timer.add @rechargeTime, @fire, this if fireWhenDone
        @beenActive = 0
