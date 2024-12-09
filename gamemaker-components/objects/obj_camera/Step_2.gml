if(is_undefined(currentCamera)) {
    return;
}

var _cameraWidth = camera_get_view_width(currentCamera);
var _cameraHeight = camera_get_view_height(currentCamera);
var _lerpPercent = 0.3;

if(is_defined(target)) {
    x = lerp(x, target.x, _lerpPercent);
    y = lerp(y, target.y, _lerpPercent);
}

var _x = floor(x - _cameraWidth / 2);
var _y = floor(y - _cameraHeight / 2);

camera_set_view_pos(currentCamera, _x, _y);