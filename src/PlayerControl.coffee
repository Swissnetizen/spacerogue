define ["Phaser"], (Phaser) ->
  exports = {}
  exports.PlayerShipMenu = class PFC ->
    constructor: (@game) ->
      @spriteArray = []
    enableControlOnSprite: (sprite) ->
      @spriteArray.push(sprite);
      sprite.inputEnabled = true
      sprite.events.onInputUp.add(@showMoveMenu, @)
    showMoveMenu: () ->
      console.dir(arguments);




