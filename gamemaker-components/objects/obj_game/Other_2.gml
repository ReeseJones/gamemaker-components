var _isWindowed = !window_get_fullscreen();
var _displayInfo = display_get_info();


if(_isWindowed) {
    window_set_size(_displayInfo.width - 400, _displayInfo.height - 400);
    window_set_position(200, 200);
}

room_set_width(rm_splash, window_get_width());
room_set_height(rm_splash, window_get_height());

room_set_width(rm_main_menu, window_get_width());
room_set_height(rm_main_menu, window_get_height());

surface_resize(application_surface, window_get_width(), window_get_height());

