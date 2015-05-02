"use strict"
define ["Phaser", "Ship", "shipMenu/menu", "planet", "pause", "beam", "collisionEvent"],
(Phaser, ship, menu, planet, pause, beam) ->
  exports = {}
  exports.PlayState = class PlayState extends Phaser.State
    create: ->
      @game.physics.startSystem Phaser.Physics.P2JS
      versionLabel = @game.add.text(
        @game.world.width-70
        5
        "v#{game.global.version}",
          font: "25px pixelated"
          fill: "#ffffff")
      game.input.keyboard.addKey(Phaser.Keyboard.ESC).onDown.add @end, this
      game.physics.p2.defaultRestitution = 0.8;
      game.ship = @ship2
      @ship1 = new ship.BaseShip(@game, 250, 200, "shuttle")
      @ship2 = new ship.BaseShip(@game, 400, 200, "shuttle")
      game.add.existing @ship1
      game.add.existing @ship2
      game.shipMenu = new menu.ShipMenu(game)
      game.add.existing game.shipMenu
      game.shipMenu.enableControlOnShip @ship1
      game.shipMenu.enableControlOnShip @ship2
      # Add planet
      @planet = new planet.Planet(@game, 250, 0, "planet")
      game.add.existing @planet
      # Create centralised timer
      game.timer = game.time.create off
      game.pauser = new pause.Pauser(game)
      game.beam = new beam.Basic(game)
      game.timer.start()

    end: ->
      game.state.start "menu"
    update: ->
  exports
