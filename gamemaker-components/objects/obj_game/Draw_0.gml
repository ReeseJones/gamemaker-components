if(!surface_exists(guiSurface)) {
    //TODO: this may need to be a power of 2 later
    guiSurface = surface_create(display_get_gui_width(), display_get_gui_height(), surface_rgba8unorm);
}

//FIGURE OUT WHY THIS DONT RENDER
if(gameStateMode == GAME_STATE_MODE.EDITOR && is_defined(editorUi)) {

    surface_set_target(guiSurface);
    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_one);
    draw_set_alpha(1);
    gpu_set_stencil_enable(true);
    gpu_set_stencil_ref(0);
    gpu_set_stencil_func(cmpfunc_always);
    draw_clear_alpha(c_black, 0);
    draw_clear_stencil(0);
    
    var _root = editorUi.root;

    ui_render_root(0, 0, _root);
    gpu_set_stencil_enable(false);
    surface_reset_target();
    gpu_set_blendmode(bm_normal);

}


if(drawDebugOverlay) {
    draw_set_color(c_red);
    draw_set_alpha(1);
    draw_rectangle(0, 0, room_width, room_height, true);
}