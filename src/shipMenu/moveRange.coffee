"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    MoveRange: class x extends Phaser.Sprite
      constructor: (@game, x, y) ->
        #Draw Circle
        key = game.make.bitmapData 1000, 1000
        key.ctx.arc 500, 500, 150, 0, 2 * Math.PI, false
        key.ctx.lineWidth = 5
        key.ctx.strokeStyle = "#FFFFFF"
        key.ctx.stroke()
        super(game, 0, 0, key)
        @kill()
        visible = false
        this
      show: (x, y) ->
        @visible = true
        this
      hide: ->
        @visible = false
        this


