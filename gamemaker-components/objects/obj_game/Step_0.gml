mouseManager.update();

if(gameStateMode == GAME_STATE_MODE.EDITOR && is_defined(editorUi)) {
    ui_calculate_layout(editorUi.root);
}

/* Todo have game update ui. disabled while uI being made.
ui_calculate_layout(id);
*/