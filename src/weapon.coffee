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
      constructor: (@game, @fleet) ->
        @beginRecharge off
        @shotSprites = []
      createSprite: ->
        @game.createSprite
      fire: ->

        

