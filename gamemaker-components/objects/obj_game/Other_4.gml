
var _isWindowed = !window_get_fullscreen();



var base_w = 1366;
var base_h = 768;
var _displayInfo = display_get_info();


if(_isWindowed) {
    window_set_size(_displayInfo.width - 400, _displayInfo.height - 400);
    window_set_position(200, 200);
}

var max_w = _isWindowed ? window_get_width() : _displayInfo.width ;
var max_h = _isWindowed ? window_get_height() : _displayInfo.height;
var aspect = _displayInfo.width / _displayInfo.height;
var VIEW_WIDTH = 0;
var VIEW_HEIGHT = 0;

if (max_w < max_h) {
    // portait
    VIEW_WIDTH = min(base_w, max_w);
    VIEW_HEIGHT = VIEW_WIDTH / aspect;
} else {
    // landscape
    VIEW_HEIGHT = min(base_h, max_h);
    VIEW_WIDTH = VIEW_HEIGHT * aspect;
}



camera_set_view_size(view_camera[0], floor(VIEW_WIDTH), floor(VIEW_HEIGHT))
view_wport[0] = max_w;
view_hport[0] = max_h;
surface_resize(application_surface, view_wport[0], view_hport[0]);