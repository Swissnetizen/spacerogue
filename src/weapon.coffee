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
        @random = new Phaser.RandomDataGenerator(Date.now())
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
      damage: 50
      noShot: 0
      nowMoving: 0
      delayBetweenShots: 50
      speed: 50
      constructor: (@game, @fleet) ->
        @beginRecharge off
        @shotSprites = [@createSprite(), @createSprite()]
        @shotSprites[0].id = 0
        @shotSprites[1].id = 1
      createSprite: ->
        sprite = @game.add.sprite 0, 0, "mute"
        @game.physics.p2.enable sprite
        sprite.body.data.shapes[0].sensor = on
        sprite.kill()
        game.physics.p2.onBeginContact.add @whenHit, {t: this, projectile: sprite}
        sprite
      fire: (target) ->
        @target = target if target
        return unless @target && @target.alive
        console.log "FIRE"
        console.log "NOWMOV: " + @nowMoving
        if @nowMoving < @shotSprites.length
          console.log "ein"
          @fireOne()
          game.timer.add 250, @fire, this
        else if @nowMoving >= @shotSprites.length
          console.log "NOW"
          game.timer.add 500, @fire, this
      fireOne: =>
        @move @target, @shotSprites[@noShot]
        @nowMoving += 1
        @noShot += 1
        console.log "FIRED"
        if @noShot >= @shotSprites.length
          console.log "begin recharge"
          @beginRecharge yes
      whenHit: ->
        return unless @t.ship
        return unless @projectile.alive
        console.log "| i | HIT!"
        _.forEach arguments, (i) =>
          # @t. = this.
          # In case argument is EMPTY
          return unless i.aabb?
          # In case there is not a bloody parent or sprite
          return unless i.parent?
          return unless i.parent.sprite?
          sprite = i.parent.sprite
          # is sprite weapon parent
          return if sprite.z == @t.ship.z or sprite.z == @projectile.z
          @projectile.kill()
          @t.nowMoving -= 1
          sprite.damage @t.damage
      move: (point, sprite) =>
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
      beginRecharge: (fireWhenDone=on) ->
        #Cannot recharge while active
        @noShot = 0
        game.timer.add @rechargeTime, @fire, this if fireWhenDone
          

