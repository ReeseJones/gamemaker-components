function game_close_debug() {
    dialog_show_question("Exit the game?", function(_shouldClose) {
        if(_shouldClose) {
            game_end();
        }
    });
}