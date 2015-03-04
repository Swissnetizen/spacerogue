"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    Planet: class Planet extends Phaser.Sprite
      constructor: (@game, x, y, key, frame) ->
        super @game, x, y, key, frame
        console.dir
        @game.physics.p2.enable this, true
        @scale.x = 5
        @scale.y = 5
        # Setup hitbox
        @radius = (Math.max @width, @height) / 2
        console.log @radius
        console.log "W: #{@width} px H: #{@height} px"
        @body.addCircle @radius, 0, 0
        # REALLY MASSIVE
        @body.dynamic = no
        console.log @z
