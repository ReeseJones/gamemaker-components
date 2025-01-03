
if(!surface_exists(guiSurface)) {
    //TODO: this may need to be a power of 2 later
    guiSurface = surface_create(display_get_gui_width(), display_get_gui_height(), surface_rgba8unorm);
}

//var _origDepth = gpu_get_depth();
surface_set_target(guiSurface);
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_one);
draw_set_alpha(1);
draw_clear_alpha(c_black, 0);
ui_render_elements(root);
surface_reset_target();
gpu_set_blendmode(bm_normal);



if(drawDebugOverlay) {
    draw_set_color(c_red);
    draw_set_alpha(1);
    draw_rectangle(0, 0, room_width, room_height, true);
}