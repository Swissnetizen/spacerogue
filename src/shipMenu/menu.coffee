"use strict"
define ["Phaser", "shipMenu/textButton"], (Phaser, textButton) ->
  exports =
    MoveRange: class MoveRange extends Phaser.Sprite
      constructor: (@game) ->
        @button = {}
        @on = {}
        #Draw Circle
        super(game, 0, 0)
        @draw(undefined, undefined, {font: "16px Ubuntu", fill: "#FFFFFF"})
        @visible = no
        # Mouse click handeler
        @inputEnabled = yes
        @events.onInputUp.add @whenClicked, this
      show: (sprite) ->
        @visible = yes
        @reset sprite.x, sprite.y
        @selectedSprite = sprite
        this
      hide: ->
        @visible = no
        @selectedSprite = undefined
        this
      whenClicked: (sprite, eventData) ->
        hitbox = @defineHitbox()
        x = eventData.x
        y = eventData.y
        # if the click is not in the circle, hide the circle and return
        @hide()
        this
      defineHitbox: ->
        # Define the circle
        new Phaser.Circle(@x, @y, 2*(@radius+@lineWidth))
      # Function to draw the range circle.
      draw: (radius, lineWidth, font) ->
        @drawCircle radius, lineWidth
        @drawButtons font
      drawCircle: (@radius=40, @lineWidth=5) ->
        # Add enough space to display the circle plus the line width.
        keySize = @radius*2+@lineWidth
        key = game.make.bitmapData keySize, keySize
        # Render the circle at the centre
        keyCentre = keySize/2
        key.ctx.arc keyCentre, keyCentre, @radius, 0, 2 * Math.PI, false
        # Set line width and colour
        key.ctx.lineWidth = @lineWidth
        key.ctx.strokeStyle = "#FFFFFF"
        # Draw
        key.ctx.stroke()
        # Load
        @loadTexture key
        #Buttons
        this
      drawButtons: (font) ->
        @missileButton = new textButton.TextButton(@game, 0, 0, "missile", font, @whenMissileButton)
        @laserButton = new textButton.TextButton(@game, 0, 0, "laser", font, @whenMissileButton)
        game.add.existing @missileButton
        game.add.existing @laserButton
        @addChild @missileButton
        @addChild @laserButton
        @missileButton.y -= @radius+@lineWidth + 10
        @laserButton.y += @radius+@lineWidth + 10
        this
      whenMissileButton: (event) =>
        console.dir arguements
#      whenLaserButton: (event) =>
#        console.dir arguements
