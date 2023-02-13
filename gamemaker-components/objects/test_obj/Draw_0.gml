/// @description Insert description here
// You can write your code in this editor
draw_self();

image_angle = 300;
image_xscale = 0.5;
image_yscale = 2;

var _inst = id;
var _xx = _inst.x
var _yy = _inst.y
var _rot = image_angle;

//get the rotated bounding box world positions
var _bbox = rect_get_rotated(_xx, _yy, 16, 64, -_rot);

draw_set_color(c_lime);
draw_line_width(_bbox.tl.x, _bbox.tl.y, _bbox.br.x, _bbox.br.y, 3);

//rotate them around origin back to be axis aligned
vector2d_inplace_rotate( _bbox.tl, _rot);
vector2d_inplace_rotate( _bbox.br, _rot);

draw_line(_bbox.tl.x, _bbox.tl.y, _bbox.br.x, _bbox.tl.y);
draw_line(_bbox.br.x, _bbox.tl.y, _bbox.br.x, _bbox.br.y);
draw_line(_bbox.br.x, _bbox.br.y, _bbox.tl.x, _bbox.br.y);
draw_line(_bbox.tl.x, _bbox.br.y, _bbox.tl.x, _bbox.tl.y);

draw_set_color(c_white);