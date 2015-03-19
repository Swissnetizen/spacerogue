"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    Pauser: class Pauser
      constructor: (@game) ->
        # Bind events and stuff
        @space = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        @space.onUp.add @toggle, this
        @paused = no
        @pauseText = new Phaser.Text(@game, 320, 270, "PAUSED",
          font: "25px pixelated"
          fill: "#fcf3f3")
        @game.add.existing @pauseText
        @pauseText.visible = no
      pause: ->
        # Pause (ship) physics and timer
        game.physics.p2.pause()
        game.timer.pause()
        @paused = yes
        @pauseText.visible = yes
      resume: ->
        # Resume ship physics and timer
        game.physics.p2.resume()
        game.timer.resume()
        @paused = no
        @pauseText.visible = no
      toggle: ->
        if @paused
          @resume()
        else
          @pause()
