image_angle += 1;
image_xscale = 0.5
image_yscale = 2;   //128

draw_self();


var _rot = image_angle;

//get the rotated bounding box world positions
var _bbox = rect_get_rotated(x, y, sprite_width / 2, sprite_height / 2, _rot);
show_debug_message($"sprite width {sprite_width}")
rect_draw_bbox(_bbox);

draw_set_color(c_lime);
draw_line_width(_bbox.tl.x, _bbox.tl.y, _bbox.br.x, _bbox.br.y, 3);

//rotate them around origin back to be axis aligned
var _pos = {x, y};
vector2d_inplace_rotate_around( _bbox.tl, _pos, _rot);
vector2d_inplace_rotate_around( _bbox.tr, _pos, _rot);
vector2d_inplace_rotate_around( _bbox.bl, _pos, _rot);
vector2d_inplace_rotate_around( _bbox.br, _pos, _rot);

draw_set_color(c_red);
rect_draw_bbox(_bbox);
draw_set_color(c_white);