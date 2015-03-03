"use strict"
define ["Phaser"], (Phaser) ->
  exports = {}
  exports.BootState = class BootState extends Phaser.State
    preload: ->
      @game.load.image "progressBar", "assets/progressBar.png"
      return
    create: ->
      # Pixel Art mode
      Phaser.Canvas.setImageRenderingCrisp @game.canvas
      # Set a background color and the physics system
      @game.stage.backgroundColor = "#222"
      @game.physics.startSystem Phaser.Physics.P2JS
      @game.state.start "load"
      return
  return exports
