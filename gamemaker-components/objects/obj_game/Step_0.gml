debugViewManager.update();
mouseManager.update();

if(gameStateMode == GAME_STATE_MODE.EDITOR && is_defined(editorUi)) {
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

var _dir = new Vec2(0,0);

if(keyboard_check(vk_left)) {
    _dir.x -= 1;
}

if(keyboard_check(vk_right)) {
    _dir.x += 1;
}

if(keyboard_check(vk_up)) {
    _dir.y -= 1;
}

if(keyboard_check(vk_down)) {
    _dir.y += 1;
    
}

if(_dir.x != 0 || _dir.y != 0) {
    var _currentCamera = view_camera[0]
    var _pos = new Vec2(camera_get_view_x(_currentCamera), camera_get_view_y(_currentCamera));
    var _fps = game_get_speed(gamespeed_fps);
    vector2d_inplace_normalize(_dir);
    vector2d_inplace_scale(_dir, 100 * 1/_fps );
    vector2d_inplace_add(_pos, _dir);
    
    camera_set_view_pos(_currentCamera, round(_pos.x), round(_pos.y));
    //show_debug_message($"FPS: {_fps}");
}
