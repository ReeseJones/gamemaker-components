var _isWindowed = !window_get_fullscreen();

var base_w = 1366;
var base_h = 768;
var _displayInfo = display_get_info();


if(_isWindowed) {
    window_set_size(_displayInfo.width - 400, _displayInfo.height - 400);
    window_set_position(200, 200);
}
