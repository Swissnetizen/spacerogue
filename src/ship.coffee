"use strict"
define ["Phaser", "_"], (Phaser, _) ->
  exports = {}
  exports.BaseShip = class BaseShip extends Phaser.Sprite
    #Properties of a ship
    maxHardPoints: 2
    maxCargo: 4,
    maxUtilPoints: 3
    maxCrew: 6
    minCrew: 2
    #Speed in px/s (2 m/s)
    speed: 125
    nom: "SHIP"
    constructor: (game, x, y, key, frame) ->
      @hardPoints = []
      @utilPoints = []
      @crew = []
      super game, x, y, key, frame
      @health = 100
      #Enable Physics
      @game.physics.p2.enable this, game.global.debug
      @destination = null
      # Helps figuring out when we've reached the destination
      @destinationSprite = game.add.sprite 0, 0, "destination"
      @destinationSprite.anchor.set .5, .5
      @destinationSprite.visible = off
      @bindings = {
        "moving" : []
      }
    move: (point, y) =>
      if typeof point == "object"
        x = point.x
        y = point.y
        @destination = point
      else
        x = point
        @destination = new Phaser.Point(x, y)
      #mavd Calculate angle
      angle = Math.atan2 (y - @y), (x - @x)
      # NOTE Correct angle of angry bullets (depends on the sprite used)
      @body.rotation = angle + game.math.degToRad 90
      # Set sprite in motion
      @body.velocity.x = (Math.cos angle) * @speed
      @body.velocity.y = (Math.sin angle) * @speed
      # Useful for player
      @fireBinding "moving", true
      @destinationSprite.reset x, y
    stop: (removeDestination) ->
      # Remove destination
      if removeDestination
        @destination = null
        @destinationSprite.visible = off
      #Stop acceleration
      @body.velocity.x = 0
      @body.velocity.y = 0
      @body.angularVelocity = 0
      @fireBinding "moving", false
    start: ->
      return unless destination
      @move @destination
    update: ->
      # Have we arrived at the destination ?
      hW = @width / 2 *.2 # Half width
      hH = @height / 2 * .2 # half height
      d = @destination
      if d? and @x - hW <= d.x <= @x + hW and @y - hH <= d.y <= @y + hH
        @stop true
    bindEvent: (event, f) ->
      return unless @bindings[event]
      @bindings[event].push f
      # Use the id Nº to remove
      @bindings[event].length
    unbindEvent: (event, id) ->
      return unless @bindings[event]
      @bindings[event][id] = null
    fireBinding: (event, data) ->
      return unless @bindings[event]
      _.each @bindings[event], (f) ->
        return if f == null
        f data
  #Return Exports
  window.BaseShip = BaseShip
  exports
