function game_ui_calculate() {
    var _game = obj_game.id;
    flexpanel_calculate_layout(_game.root.flexNode, window_get_width(), window_get_height(), flexpanel_direction.LTR);
    ui_calculate_element_positions(_game.root);
}