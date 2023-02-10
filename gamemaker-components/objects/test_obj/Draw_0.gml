/// @description Insert description here
// You can write your code in this editor
draw_self();

image_angle = 300;
image_xscale = 0.5;
image_yscale = 2;

var inst = id;
var xx = inst.x
var yy = inst.y
var rot = image_angle;
			
//get the rotated bounding box world positions
var bbox = rect_get_rotated(xx, yy, 16, 64, -rot);
		
draw_set_color(c_lime);
draw_line_width(bbox.tl.x, bbox.tl.y, bbox.br.x, bbox.br.y, 3);
		
//rotate them around origin back to be axis aligned
vector2d_inplace_rotate( bbox.tl, rot);
vector2d_inplace_rotate( bbox.br, rot);
		
draw_line(bbox.tl.x, bbox.tl.y, bbox.br.x, bbox.tl.y);
draw_line(bbox.br.x, bbox.tl.y, bbox.br.x, bbox.br.y);
draw_line(bbox.br.x, bbox.br.y, bbox.tl.x, bbox.br.y);
draw_line(bbox.tl.x, bbox.br.y, bbox.tl.x, bbox.tl.y);

draw_set_color(c_white);