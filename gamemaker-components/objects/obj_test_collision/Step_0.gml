/// @description Insert description here
// You can write your code in this editor

x = mouse_x;
y = mouse_y;

if(place_meeting(x,y, obj_solid)) {
	image_blend = c_red;	
} else {
	image_blend = c_white;	
}