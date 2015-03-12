"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    BasicWeapon: class BasicWeapon extends Phaser.Sprite
      damage: 10
      # How many HP will the damage vary
      variation: 2
      #An interger or percentage of the chance to hit.
      accuracy: 800 / 1000
      name: "BasicWeapon"
      maxDistance: 200
      constructor: (@game, @fleet) ->
        super @game, 0, 0, "mute"
        @game.physics.p2.enable this, game.global.debug
        # VERY SMALL MASS
        console.dir this
        @body.mass = 0.1e-100
        @game.physics.p2.onBeginContact.add @contact, this
        @game.add.existing this
        @beam = game.add.graphics 0, 0
      # Fire
      fire: (ship, target) ->
        @direction = new Phaser.Line()
        @direction.fromSprite ship, target
        @ship = ship
        @target = target
        @move ship.x, ship.y, target.x, target.y
      move: (startX, startY, finishX, finishY) =>
        # Calculate angle
        angle = Math.atan2 finishY - startY, finishX - startX
        # NOTE Correct angle of angry bullets (depends on the sprite used)
        @body.rotation = angle + game.math.degToRad 90
        # Set sprite in motion
        @reset startX+52, startY
        # Goes at 10× the distance, it should reach the destination in less than 1 ds
        @body.velocity.x = Math.cos(angle) * @direction.length * 10
        @body.velocity.y = Math.sin(angle) * @direction.length * 10
      contact: (obj1, obj2) ->
        # NOTE obj1.parent.sprite is the sprite. obj
        # Each sprite MUST have
        return unless obj1.parent and obj2.parent
        console.log "HI"
        return unless obj1.parent.sprite == this or obj2.parent.sprite == this
        return unless obj2.parent.sprite == @target or obj1.parent.sprite == @target
        @kill()
        @draw @ship, @target
        @game.physics.p2.onBeginContact.remove @contact
        return false
      draw: (from, to) ->
        console.log "(HELLO)"
        @beam.lineStyle 5, 0xFF0000, 1
        @beam.moveTo from.x, from.y
        @beam.lineTo to.x, to.y
        @game.timer
