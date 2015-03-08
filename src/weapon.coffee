"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    BasicWeapon: class BasicWeapon
      damage: 10
      # How many HP will the damage vary
      variation: 2
      #An interger or percentage of the chance to hit.
      accuracy: 800 / 1000
      name: "BasicWeapon"
      maxDistance = 200
      constructor: (@game, @fleet) ->
        @canShoot = game.add.sprite 0, 0, "mute"
        @game.physics.p2.enable @canShoot, game.global.debug
        @canShoot.body.mass= 0.1e-100
        console.dir @canShoot
        console.log "X"
        game.physics.p2.onBeginContact.add @contact, this
        @can
      # Fire
      fire: (ship, target) ->
        direction = new Phaser.Line()
        direction.fromSprite ship, target
        @moveCanShoot ship.x, ship.y, target.x, target.y
      moveCanShoot: (startX, startY, finishX, finishY) =>
        # Calculate angle
        angle = Math.atan2 finishY - startY, finishX - startX
        # NOTE Correct angle of angry bullets (depends on the sprite used)
        @canShoot.body.rotation = angle + game.math.degToRad 90
        # Set sprite in motion
        @canShoot.reset startX+52, startY
        @canShoot.body.velocity.x = Math.cos(angle) * 20
        @canShoot.body.velocity.y = Math.sin(angle) * 20
      contact: () ->
          console.dir arguments
          @canShoot.kill()
          return false
