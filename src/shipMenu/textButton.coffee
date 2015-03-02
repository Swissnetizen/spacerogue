"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    TextButton: class TextButton extends Phaser.Button
      constructor: (@game, x, y, text, style, callback, context) ->
        #Setup text
        @text = new Phaser.Text(@game, 0, 0, text, style)
        #Set up button
        super @game, x, y, @text.texture, callback, context
        @anchor.set .5, .5
      reloadText: ->
        @loadTexture @text.texture
