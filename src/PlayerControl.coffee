"use strict"
define ["Phaser"], (Phaser) ->
  exports = {}
  exports.PlayerShipMenu = class PlayerShipMenu
    constructor: (@game) ->
      @spriteArray = []
      #Menu
      @createUi()
    enableControlOnSprite: (sprite) ->
      @spriteArray.push sprite
      sprite.inputEnabled = true
      sprite.events.onInputUp.add @showMoveRange, this
    showMoveRange: (sprite, eventData, something) ->
      console.log "HI"
      console.dir arguments
      @moveRange.reset sprite.x, sprite.y, 1
    #Create UI elements for later use.
    createUi: ->
     @ui = new Phaser.Group(game, null, "PlayerShipMenu", false, true, Phaser.Physics.P2JS)
     @createMoveRange()
     this
    createMoveRange: ->
      #Draw Circle
      key = game.make.bitmapData 1000, 1000
      key.ctx.arc 500, 500, 150, 0, 2 * Math.PI, false
      key.ctx.lineWidth = 5;
      key.ctx.strokeStyle = "#FFFFFF"
      key.ctx.stroke()
      @moveRange = new Phaser.Sprite(game, 0, 0, key)
      @ui.add @moveRange
      @moveRange.kill()
      @game.add.existing @moveRange
    showMoveRange: ->
  exports
