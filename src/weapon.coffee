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
      maxDistance: 200
      constructor: (@game, @fleet) ->
        @canShoot = game.add.sprite 0, 0, "mute"
        @game.physics.p2.enable @canShoot, game.global.debug
        @canShoot.body.mass= 0.1e-100
        console.dir @canShoot
        console.log "X"
        @game.physics.p2.onBeginContact.add @contact, this
        @can
      # Fire
      fire: (ship, target) ->
        direction = new Phaser.Line()
        direction.fromSprite ship, target
        @ship = ship
        @target = target
        @moveCanShoot ship.x, ship.y, target.x, target.y
      moveCanShoot: (startX, startY, finishX, finishY) =>
        # Calculate angle
        angle = Math.atan2 finishY - startY, finishX - startX
        # NOTE Correct angle of angry bullets (depends on the sprite used)
        @canShoot.body.rotation = angle + game.math.degToRad 90
        # Set sprite in motion
        @canShoot.reset startX+52, startY
        @canShoot.body.velocity.x = Math.cos(angle) * 50
        @canShoot.body.velocity.y = Math.sin(angle) * 50
      contact: (obj1, obj2) ->
        # NOTE obj1.parent.sprite is the sprite. obj
        # Each sprite MUST have
        return unless obj1.parent and obj2.parent
        console.log "HI"
        console.dir obj1.parent.sprite
        console.dir obj2.parent.sprite
        return unless obj1.parent.sprite == @canShoot or obj2.parent.sprite == @canShoot
        console.log "PASS TEST 1"
        return unless obj2.parent.sprite == @target or obj1.parent.sprite == @target
        console.log "passing 2"
        @canShoot.kill()
        @game.physics.p2.onBeginContact.remove @contact
        return false
