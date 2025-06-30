game_calculate_ui();

debugViewManager.update();
mouseManager.update();


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