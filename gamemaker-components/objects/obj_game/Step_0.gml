mouseManager.update();

if(gameStateMode == GAME_STATE_MODE.EDITOR && is_defined(editorUi)) {
    ui_calculate_layout(editorUi.root);
    
    var _mouseX = device_mouse_x_to_gui(0);
    var _mouseY = device_mouse_y_to_gui(0);
    var _currentMouseElement = ui_element_at_point(_mouseX, _mouseY, editorUi.root);

    if(_currentMouseElement != prevMouseElement) {
        if(!is_undefined(prevMouseElement)) {
            mouse_manager_handle_mouse_out(prevMouseElement);
        }
        mouse_manager_handle_mouse_over(_currentMouseElement);

        prevMouseElement = _currentMouseElement;
    }
}

/* Todo have game update ui. disabled while uI being made.
ui_calculate_layout(id);
*/