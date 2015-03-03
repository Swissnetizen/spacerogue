# Initialize Phaser
requirejs.config (
    baseUrl: "js"
    paths:
      Phaser:   "../phaser"
)
require ["Phaser", "boot", "load", "menu", "play"], (Phaser, boot, load, menu, play) ->
  "use strict"
  window.game = new Phaser.Game(500, 350, Phaser.AUTO, "gameDiv")
  # Our "globals" variable
  game.global =
    score: 0
    boardSize: 1000
    version: "0.1.0"
  # Define states
  game.state.add "boot", new boot.BootState
  game.state.add "load", new load.LoadState
  game.state.add "menu", new menu.MenuState
  game.state.add "play", new play.PlayState
  # Start the "boot" state
  game.state.start "boot"
