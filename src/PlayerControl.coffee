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
      sprite.events.onInputUp.add @onSpriteClicked, this

    onSpriteClicked: (sprite, eventData, something) ->
      unless @moveRange.visible
        @moveRange.show sprite.x, sprite.y
      else if @moveRange.visible
          @moveRange.hide()

    #Create UI elements for later use.
    createUi: ->
      @ui = new Phaser.Group(game, null, "PlayerShipMenu", false, true, Phaser.Physics.P2JS)
      #Setup moveRange viewer
      @moveRange = new moveRange.MoveRange(@game, 0, 0)
      #Ui hider
      @ui.add @moveRange
      game.add.existing @moveRange

  exports
