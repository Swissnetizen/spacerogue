"use strict"
define ["Phaser", "shipMenu/textButton"], (Phaser, textButton) ->
  exports =
    ShipMenu: class ShipMenu extends Phaser.Sprite
      constructor: (@game) ->
        @shipArray = []
        @button = {}
        @on = {}
        #Draw Circle
        super game, 0, 0
        @draw undefined, undefined, {font: "16px pixelated", fill: "#FFFFFF"}
        @visible = no
        #Anchor
        @anchor.set .5, .5
        # Mouse click handeler
        @inputEnabled = yes
        @events.onInputUp.add @whenClicked, this
        #Where to move when the menu is open
        key = game.make.bitmapData @game.global.boardSize, @game.global.boardSize
        @detectingBox = new Phaser.Sprite(@game, 0, 0, key)
        @game.add.existing @detectingBox
        @detectingBox.events.onInputUp.add @whenClickDetecting,  this
      enableControlOnShip: (ship) ->
        @shipArray.push ship
        ship.inputEnabled = yes
        ship.input.priorityID = 3
        ship.events.onInputUp.add @whenShipClicked, this
      whenShipClicked: (ship, eventData, something) ->
        if @targeting
          @whenShipClickedTargeting ship, eventData, something
          return
        # Not visible
        unless @visible
          @show ship
        # Visible and around the current ship
        else if @visible and @selectedShip == ship
          @hide()
        # Visible around a different ship
        else if @visible and @selectedShip != ship
          @show ship
        true
      show: (ship) ->
        @visible = yes
        # Reset position
        @reset ship.x, ship.y
        @hitbox = @defineHitbox()
        @selectedShip = ship
        # Make it possible to move
        @detectingBox.inputEnabled = yes
        # Stop movement
        @selectedShip.stop no
        this
      hide: ->
        @visible = no
        @selectedShip = undefined
        @detectingBox.inputEnabled = no
        @targeting = no
        this
      whenClicked: (ship, eventData) ->
        x = eventData.x
        y = eventData.y
        # if the click is in the circle, hide the menu and return
        if @hitbox.contains x, y
          @hide()
        this
      #When we are targeting and a ship was clicked
      whenShipClickedTargeting: (ship) =>
        # Cannot target self
        return @hide() if ship == @selectedShip
        @game.laser.setTarget @selectedShip, ship
      defineHitbox: ->
        # Define the circle
        new Phaser.Circle(@x, @y, 2*(@radius+@lineWidth))
      # Draw everything needed
      draw: (radius, lineWidth, font) ->
        @drawCircle radius, lineWidth
        @drawButtons font
        # Detects where to move when the player opens the menu
      whenClickDetecting: (ship, eventData, someting) ->
        x = eventData.x
        y = eventData.y
        ship = @selectedShip
        @when
        # Is the click in the menu circle?
        return if @hitbox.contains x, y
        ship.move new Phaser.Point(x, y)
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
        # TODO: Implement missile and laser functionnality
      whenMissileButton: (event) ->
        @targeting = yes

#      whenLaserButton: (event) ->
