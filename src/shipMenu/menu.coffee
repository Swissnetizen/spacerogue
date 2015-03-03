"use strict"
define ["Phaser", "shipMenu/textButton"], (Phaser, textButton) ->
  exports =
    MoveRange: class MoveRange extends Phaser.Sprite
      constructor: (@game) ->
        @button = {}
        @on = {}
        #Draw Circle
        super game, 0, 0
        @draw undefined, undefined, {font: "16px Ubuntu", fill: "#FFFFFF"}
        @visible = no
        #Anchor
        @anchor.set .5, .5
        # Mouse click handeler
        @inputEnabled = yes
        @events.onInputUp.add @whenClicked, this
        #Where to move when the menu is open
        key = game.make.bitmapData @game.global.boardSize, @game.global.boardSize
        @detectingBox = new Phaser.Sprite(@game, 0, 0, key)
        game.add.existing @detectingBox
        @detectingBox.scale.set 10, 10
        @detectingBox.events.onInputUp.add @whenClickDetecting,  this
#        # Input stuff
#        @detectingBox.inputEnabled = yes
#        @detectingBox.input.priorityID = 0
#        @detectingBox.inputEnabled = no
        console.dir @detectingBox
      show: (sprite) ->
        @visible = yes
        # Reset position
        @reset sprite.x, sprite.y
        @hitbox = @defineHitbox()
        @selectedSprite = sprite
        # Make it possible to move
        @detectingBox.inputEnabled = yes
        # Stop movement
        @selectedSprite.body.velocity.x = 0
        @selectedSprite.body.velocity.y = 0
        this
      hide: ->
        @visible = no
        @selectedSprite = undefined
        @detectingBox.inputEnabled = no
        this
      whenClicked: (sprite, eventData) ->
        x = eventData.x
        y = eventData.y
        # if the click is in the circle, hide the menu and return
        if @hitbox.contains x, y
          @hide()
        this
      defineHitbox: ->
        # Define the circle
        new Phaser.Circle(@x, @y, 2*(@radius+@lineWidth))
      # Draw everything needed
      draw: (radius, lineWidth, font) ->
        @drawCircle radius, lineWidth
        @drawButtons font
        # Detects where to move when the player opens the menu
      whenClickDetecting: (sprite, eventData, someting) ->
        x = eventData.x
        y = eventData.y
        ship = @selectedSprite
        # Is the click in the menu circle?
        return if @hitbox.contains x, y
        # Calculate angle
        console.log "move"
        angle = Math.atan2 y - ship.y, x - ship.x
        # Correct angle of angry bullets (depends on the sprite used)
        ship.body.rotation = angle + game.math.degToRad 90
        # Set sprite in motion
        ship.body.velocity.x = Math.cos(angle) * ship.speed
        ship.body.velocity.y = Math.sin(angle) * ship.speed
        # Hide Menu
        @hide()
      drawCircle: (@radius=40, @lineWidth=5) ->
        # Add enough space to display the circle plus the line width.
        keySize = 2 * @radius+@lineWidth
        key = game.make.bitmapData keySize, keySize
        # Render the circle at the centre
        keyCentre = keySize / 2
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
        @missileButton = new textButton.TextButton(@game, 0, 0, "missile", font, @whenMissileButton, this)
        @laserButton = new textButton.TextButton(@game, 0, 0, "laser", font, @whenMissileButton, this)
        game.add.existing @missileButton
        game.add.existing @laserButton
        # Add to parent as child
        @addChild @missileButton
        @addChild @laserButton
        @missileButton.y += @radius+@lineWidth + 10
        @laserButton.y -= @radius+@lineWidth + 10
        #Set priority ID allowing events to be dispatched
        @missileButton.input.priorityID = 1
        @laserButton.input.priorityID = 1
        this
      whenMissileButton: (event) ->
        console.dir(arguments)
#      whenLaserButton: (event) ->
#        console.dir arguements
