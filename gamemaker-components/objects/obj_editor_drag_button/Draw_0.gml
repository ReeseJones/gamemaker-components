draw_self();

if(dragging) {
    draw_sprite_ext(sprite_index, 0, mouse_x, mouse_y, image_xscale, image_yscale, 0, c_white, 0.5);
}