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
      maxDistance: 2000 # px
      timeActive: 3000 # ms
      rechargeTime: 2000 # ms
      beenActive: 0 # ms
      beamsActive: no
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
        @ship.bindEvent("moving", (isMoving) => 
          console.log "WTF"
          @beginRecharge() if isMoving
        )
        # Go over line to find intersections
        # Draw attack laser thing if TRUE
        @fire()
      fire: ->
        # Need to have target and ship
        return unless @target and @ship
        @direction.fromSprite @ship, @target
        # Can we get the target ?
        if not @canFire() or @beamActive
          #Check laterz
          @game.timer.add 100, @fire, this
          return
        # We can get the target
        # Draw laser beamz (in a timer thing cos otherwise it would draw when paused)
        @game.timer.add 1, @draw, this
        # Start the firing loop
        @game.timer.add 1, @whenFiring, this
        @beamActive = true
      canFire: () ->
        possible = yes
        # in range? (I'm not too sure how it works though)
        return no if @direction.length > @maxDistence
        # THEY MUST BOTH exist
        return no unless @target and @ship
        # Is the ship we're shooting from movingL
        return no if @shooterMoving 
        # Check if line intersects any entity apart from
        # ship or target
        coordsOnLine = @direction.coordinatesOnLine 5
        intersects = false
        for coord in coordsOnLine
          coord = {x: coord[0], y: coord[1]}
          entitiesIntersecting = @game.physics.p2.hitTest coord
          for entity in entitiesIntersecting
            id = entity.id
            if id == @ship.body.id or id == @target.body.id
              continue
            else
              intersects = true
              break
          break if intersects
        return no if intersects
        return possible
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
        # Prevents infinte loop
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
        if @beenActive > @timeActive || not @canFire()
          @beginRecharge()
          return
        #Is the the target still in the beam?
        pointingTo = @game.physics.p2.hitTest @direction.end, [@target], 2, yes
        unless pointingTo.length == 1 && pointingTo[0].parent == @target.body
          # By adding a tiny delay, it will gurantee 
          # that the beam will not be cleared when 
          # paused
          @beenActive += .0001
          game.timer.add .0001, =>
            @endBeam()
            @fire()
          return
        # Damage
        @target.damage @damage / (@timeActive * .1)
        @target = null if @target.health <= 0
        game.timer.add 1, @whenFiring
      beginRecharge: (fireWhenDone=on) ->
        #Cannot recharge while active
        @endBeam()
        game.timer.add @rechargeTime, @fire, this if fireWhenDone
        @beenActive = 0
      endBeam: ->
        @beamActive = false
        @beamGraphic.clear()

