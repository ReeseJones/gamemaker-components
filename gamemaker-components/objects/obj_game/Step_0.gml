debugViewManager.update();
mouseManager.update();
enemyManager.step();

flexpanel_calculate_layout(root, window_get_width(), window_get_height(), flexpanel_direction.LTR);

if(is_defined(editorUi)) {
    var _root = editorUi.root;
    ui_calculate_layout(_root);

    var _mouseX = device_mouse_x_to_gui(0);
    var _mouseY = device_mouse_y_to_gui(0);
    var _currentMouseElement = ui_element_at_point(_mouseX, _mouseY, _root);

    if (_currentMouseElement != prevMouseElement) {
        if(!is_undefined(prevMouseElement)) {
            mouse_manager_handle_mouse_out(prevMouseElement);
        }
        if(is_defined(_currentMouseElement)) {
            mouse_manager_handle_mouse_over(_currentMouseElement);
        }
        prevMouseElement = _currentMouseElement;
    }
}


