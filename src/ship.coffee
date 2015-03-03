"use strict"
define ["Phaser"], (Phaser) ->
  exports = {}
  exports.BaseShip = class BaseShip extends Phaser.Sprite
    #Properties of a ship
    maxHardPoints: 2
    #Will result in death when this reaches 0
    health: 100
    maxCargo: 4,
    maxUtilPoints: 3
    maxCrew: 6
    minCrew: 2
    #Speed in px/s (m/s)
    speed: 125
    constructor: (game, x, y, key, frame) ->
      @hardPoints = []
      @utilPoints = []
      @crew = []
      super game, x, y, key, frame
      #Enable Physics
      @game.physics.p2.enable this
      @destination = null
      # Helps figuring out when we've reached the destination
      @destinationSprite = game.add.sprite 0, 0, "destination"
      @destinationSprite.anchor.set .5, .5
      @destinationSprite.visibility = off
    move: (point, y) =>
      if typeof point == "object"
        x = point.x
        y = point.y
        @destination = point
      else
        x = point
        @destination = new Phaser.Point(x, y)
      # Calculate angle
      angle = Math.atan2 y - @y, x - @x
      # NOTE Correct angle of angry bullets (depends on the sprite used)
      @body.rotation = angle + game.math.degToRad 90
      # Set sprite in motion
      @body.velocity.x = Math.cos(angle) * @speed
      @body.velocity.y = Math.sin(angle) * @speed
      console.log "X: #{x} Y: #{y}"
      #Destination sprite (used to calculate wheather or not it has reached the destination
      @destinationSprite.reset x, y
    stop: (removeDestination)->
      # Remove destination
      @destination = null if removeDestination
      #Stop acceleration
      @body.velocity.x = 0
      @body.velocity.y = 0
      @body.angularVelocity = 0
    update: ->
      if @destination? and Math.round(@x) == @destination.x and Math.round(@y) == @destination.y
        @stop false
      console.log Phaser.Rectangle.contains @, @x, @y
  #Return Exports
  exports
