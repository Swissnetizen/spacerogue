"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    Pauser: class Pauser
      constructor: (@game) ->
        # Bind events and stuff
        @space = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        @space.onUp.add @toggle, this
        @paused = no
      pause: ->
        # Pause (ship) physics and timer
        game.physics.p2.pause()
        game.timer.pause()
        @paused = yes
      resume: ->
        # Resume ship physics and timer
        game.physics.p2.resume()
        game.timer.resume()
        @paused = no
      toggle: ->
        if @paused
          @resume()
        else
          @pause()
