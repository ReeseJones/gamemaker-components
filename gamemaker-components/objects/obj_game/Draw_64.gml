
if(surface_exists(guiSurface)) {
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_surface(guiSurface, 0, 0);
}

flexpanel_debug_draw_node(root);