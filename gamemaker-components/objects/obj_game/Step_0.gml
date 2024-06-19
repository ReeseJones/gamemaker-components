mouseManager.update();

if(gameStateMode == GAME_STATE_MODE.EDITOR && is_defined(editorUi)) {
    var _width = window_get_width();
    var _height = window_get_height();
    ui_calculate_layout(editorUi.root, _width, _height);
}

/* Todo have game update ui. disabled while uI being made.
ui_calculate_layout(id);
*/