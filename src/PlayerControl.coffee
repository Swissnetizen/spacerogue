"use strict"
define ["Phaser", "shipMenu/moveRange"], (Phaser, moveRange) ->
  exports = {}
  exports.PlayerShipMenu = class PlayerShipMenu
    constructor: (@game) ->
      @spriteArray = []
      #Menu
      @createUi()

    enableControlOnSprite: (sprite) ->
      @spriteArray.push sprite
      sprite.inputEnabled = true
      sprite.events.onInputUp.add @whenSpriteClicked, this

    whenSpriteClicked: (sprite, eventData, something) ->
      # Not visible
      console.log "0"
      unless @moveRange.visible
        console.log "1"
        @moveRange.show sprite
      # Visible and around the current sprite
      else if @moveRange.visible and @moveRange.around == sprite
        console.log "2"
        @moveRange.hide()
      # Visible around a different sprite
      else if @moveRange.visible and @moveRange.around != sprite
        console.log "3"
        @moveRange.show sprite
      true
    #Create UI elements for later use.
    createUi: ->
      @ui = new Phaser.Group(game, null, "PlayerShipMenu", false, true, Phaser.Physics.P2JS)
      #Setup moveRange viewer
      @moveRange = new moveRange.MoveRange(@game, 0, 0)
      #Ui hider
      @ui.add @moveRange
      game.add.existing @moveRange

  exports
