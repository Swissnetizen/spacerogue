# Initialize Phaser
requirejs.config (
    baseUrl: "js"
    paths:
      Phaser:   "../phaser"
      _: "../lodash"
)
require ["Phaser", "boot", "load", "menu", "play"], (Phaser, boot, load, menu, play) ->
  "use strict"
  window.game = new Phaser.Game(640, 360, Phaser.AUTO, "gameDiv")
  # Our "globals" variable
  game.global =
    score: 0
    boardSize: 1000
    version: "0.2.0"
    debug: on
  # Define states
  game.state.add "boot", new boot.BootState
  game.state.add "load", new load.LoadState
  game.state.add "menu", new menu.MenuState
  game.state.add "play", new play.PlayState
  # Start the "boot" state
  game.state.start "boot"
