var _col = draw_get_color();

draw_set_color(c_white);
mech_system_draw(mechSystem);

draw_set_color(_col);
draw_line(room_width / 2, 0, room_width / 2, room_height);
draw_line(0, room_height / 2, room_width, room_height / 2)

//ds_grid_draw_debug(mechComponentGrid, 0, 0);