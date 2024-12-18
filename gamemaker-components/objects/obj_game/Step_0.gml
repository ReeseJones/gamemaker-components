//Make sure UI is layed out first.
flexpanel_calculate_layout(root.flexNode, window_get_width(), window_get_height(), flexpanel_direction.LTR);
ui_calculate_element_positions(root);

debugViewManager.update();
mouseManager.update();
enemyManager.step();


var _mouseX = device_mouse_x_to_gui(0);
var _mouseY = device_mouse_y_to_gui(0);
var _currentMouseElement = ui_element_at_point(_mouseX, _mouseY, root);

if (_currentMouseElement != prevMouseElement) {
    if(!is_undefined(prevMouseElement)) {
        mouse_manager_handle_mouse_out(prevMouseElement);
    }
    if(is_defined(_currentMouseElement)) {
        mouse_manager_handle_mouse_over(_currentMouseElement);
    }
    prevMouseElement = _currentMouseElement;
}


