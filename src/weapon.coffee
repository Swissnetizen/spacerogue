"use strict"
define ["Phaser", "_"], (Phaser) ->
  exports =
    Base: class Base
      damage: 20
      # How many HP will the damage vary
      variation: 2
      #An interger or percentage of the chance to hit.
      accuracy: 800 / 1000
      name: "Weapon"
      rechargeTime: 2000
      constructor: (@game, @fleet) ->
        console.dir this
        @direction = new Phaser.Line()
        @beginRecharge off
      # set Target
      setTarget: (ship, target) ->
        @ship = ship
        @target = target
        # Go over line to find intersections
        # Draw attack laser thing if TRUE 
        @fire()
      fire: ->
      canFire: ->
        @fail = no
        return yes if @direction.length > @maxDistence
        return !@fail
      whenFiring: =>
      beginRecharge: (fireWhenDone=on) ->
        #Cannot recharge while active
        game.timer.add @rechargeTime, @fire, this if fireWhenDone
    Projectile: class Projectile extends Base
      noShots: 1
      delayBetweenShots: 50
      speed: 50
      constructor: (@game, @fleet) ->
        @beginRecharge off
        @shotSprites = [@createSprite()]
      createSprite: ->
        sprite = @game.add.sprite 0, 0, "mute"
        @game.physics.p2.enable sprite
        sprite.body.data.shapes[0].sensor = on
        game.physics.p2.onBeginContact.add @whenHit, this
        sprite
      fire: ->
        console.log "FIRE"
        @move @target, @shotSprites[0]
      whenHit: ->
        console.dir arguments

      move: (point, sprite) =>
        console.log "MOVE"
        x = point.x
        y = point.y
        sprite.reset @ship.x, @ship.y
        # Calculate angle
        angle = Math.atan2 y - sprite.y, x - sprite.x
        # NOTE Correct angle of angry bullets (depends on the sprite used)
        sprite.body.rotation = angle + game.math.degToRad 90
        # Set sprite in motion
        sprite.body.velocity.x = Math.cos(angle) * @speed
        sprite.body.velocity.y = Math.sin(angle) * @speed
          

