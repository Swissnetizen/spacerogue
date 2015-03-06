"use strict"
define ["Phaser", "Ship", "shipMenu/menu", "planet", "pause"], (Phaser, ship, menu, planet, pause) ->
  exports = {}
  exports.PlayState = class PlayState extends Phaser.State
    create: ->
      versionLabel = @game.add.text(
        @game.world.width-70
        5
        "v#{game.global.version}",
          font: "25px pixelated"
          fill: "#ffffff")
      game.input.keyboard.addKey(Phaser.Keyboard.ESC).onDown.add @end, this
      game.physics.p2.defaultRestitution = 0.8;
      @ship1 = new ship.BaseShip(@game, 250, 200, "shuttle")
      @ship2 = new ship.BaseShip(@game, 400, 200, "shuttle")
      game.add.existing @ship1
      game.add.existing @ship2
      game.shipMenu = new menu.ShipMenu(game)
      game.add.existing game.shipMenu
      game.shipMenu.enableControlOnSprite @ship1
      game.shipMenu.enableControlOnSprite @ship2
      # Add planet
      @planet = new planet.Planet(@game, 250, 0, "planet")
      game.add.existing @planet
      # Create centralised timer
      game.timer = new Phaser.Timer(game)
      game.pauser = new pause.Pauser(game)
    end: ->
      game.state.start "menu"
    update: ->
  exports
