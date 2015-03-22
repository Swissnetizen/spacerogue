"use strict"
define ["Phaser", "_"], (Phaser, _) ->
  exports =
    CollisionEvent: class CollisionEvent
      constructor: (@game, name) ->
        @array = []
        @game.physics.p2[name].add @fire, this
      add: (sprite1, sprite2, callback, context, once=no) ->
        return unless sprite1 and sprite2 and callback
        @array.push {
          sprite1
          sprite2
          callback
          context
          once
        }
        # Return Index
        @array.length-1
      addOnce: (sprite1, sprite2, callback, context) ->
        @add sprite1, sprite2, callback, context, yes
      remove: (callback, index) ->
        # We know what index the callback exists at
        if index
          @array = @array.splice index, 1
          return
        # We don't know which index it exists at
        @array.forEach (object, index) =>
          if object.callback == callback
            # Splice: start removing at the INDEX № of items to remove: 1
            @array = @array.splice index, 1
      fire: (body1, body2) ->
        sprite1 = body1.parent
        sprite2 = body2.parent
        console.log "HI YA HI"
        _.each @array, (o) =>
          # If none of the sprites have any relationship to the other sprites return
          # if sprite1 or 2 are null, we only care about the second one having a relationship
          console.log "0"
          console.dir o
          console.dir sprite1
          if o.sprite1 == null
            isNull1 = yes
            return unless o.sprite2.id == sprite1.id or o.sprite2.id == sprite2.id
          else if o.sprite2 == null
            isNull2 = yes
            return unless o.sprite1.id == sprite1.id or o.sprite1.id == sprite2.id
          # Both must have a relationship
          else unless (o.sprite1.id == sprite1.id and o.sprite2.id == sprite2.id) or
                      (o.sprite2.id == sprite2.id and o.sprite1.id == sprite2.id)
            return
          console.log 2
          # They do have a relationship, fire the event handler
          (o.callback.bind o.context)(unless isNull1? then sprite1)
          @remove null, index if o.once





