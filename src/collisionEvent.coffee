"use strict"
define ["Phaser"], (Phaser) ->
  exports =
    thing: class thing
      constructor: @array ->
      add: (sprite1, sprite2, callback, context, once=no) ->
        @array.push {
          sprite1
          sprite2
          callback
          context
          once
        }
      addOnce: (sprite1, sprite2, callback, context) ->
        add sprite1, sprite2, callback, context
      remove: callback ->
        @array.forEach (handler, index) =>
          if handler == callback
            @array = @array.
    onCollide: class onCollide
      constructor: @game ->
        @game.physics.p2.onBeginContact.add @whenBeginContact, this
        @game.physics.p2.onEndContact.add @whenEndContact, this
        @beginContactListeners = []
        @endContactListeners = []
      whenContact: (name, args) ->

      BeginContact



