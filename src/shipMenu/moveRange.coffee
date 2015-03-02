"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    MoveRange: class MoveRange extends Phaser.Sprite
      constructor: (@game) ->
        #Draw Circle
        super(game, 0, 0)
        @draw()
        @visible = no
        # Mouse click handeler
        @inputEnabled = no
        @events.onInputUp.add @whenClicked, this

      show: (sprite) ->
        @visible = yes
        @reset sprite.x, sprite.y
        @selectedSprite = sprite
        this

      hide: ->
        @visible = no
        @aroundSprite = undefined
        this

      whenClicked: (sprite, eventData) ->

      # Function to draw the range circle
      draw: (radius=150, lineWidth=5) ->
        # Add enough space to display the circle plus the line width.
        keySize = radius*2+lineWidth
        key = game.make.bitmapData keySize, keySize
        # Render the circle at the centre
        keyCentre = keySize/2
        key.ctx.arc keyCentre, keyCentre, radius, 0, 2 * Math.PI, false
        # Set line width and colour
        key.ctx.lineWidth = lineWidth
        key.ctx.strokeStyle = "#FFFFFF"
        # Draw
        key.ctx.stroke()
        # Load
        @loadTexture key
        this

