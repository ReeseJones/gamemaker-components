draw_set_color(c_red);
draw_set_alpha(1);

var _camWidth = camera_get_view_width(currentCamera);
var _camHeight = camera_get_view_height(currentCamera);

draw_rectangle(0, 0, _camWidth, _camHeight, true);