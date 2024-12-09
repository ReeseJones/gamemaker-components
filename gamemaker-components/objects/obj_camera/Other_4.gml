var _displayInfo = display_get_info();
var _isFullscreen = window_get_fullscreen();

var _max_w = _isFullscreen ? _displayInfo.width: window_get_width();
var _max_h = _isFullscreen ? _displayInfo.height: window_get_height();

// eg: 16/9 = 1.77777777778 ----- 1000 / 1.77777777778 = 562.499999999
var _aspect = _max_w / _max_h;


if (_max_w < _max_h) {
    // portait
    var _width = floor(cameraMaxWorldDimension * _aspect);
    var _height = floor(cameraMaxWorldDimension);
    camera_set_view_size(currentCamera, _width, _height);
} else {
    // landscape
    var _width = floor(cameraMaxWorldDimension);
    var _height = floor(cameraMaxWorldDimension / _aspect);
    camera_set_view_size(currentCamera, _width, _height);
}


surface_resize(application_surface, _max_w, _max_h);


view_enabled = true;
view_set_visible(viewIndex, true);
view_set_camera(viewIndex, currentCamera);
view_set_wport(viewIndex, _max_w);
view_set_hport(viewIndex, _max_h);
view_set_xport(viewIndex, 0);
view_set_yport(viewIndex, 0);