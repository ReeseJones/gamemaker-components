draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_text(32, 32, $"Current Room: {room_get_name(room)}");

if( is_undefined(editorUi) ) {
    exit;
}

with(obj_ui_element) {
    if(visible && is_defined(sprite_index) && sprite_index > 0) {
        var _xx = calculatedSize.position.left;
        var _yy = calculatedSize.position.top;
        var _widthScale = calculatedSize.width / sprite_get_width(sprite_index);
        var _heightScale = calculatedSize.height / sprite_get_height(sprite_index);
        draw_sprite_ext(sprite_index, 0, _xx,  _yy, _widthScale, _heightScale, 0, image_blend, image_alpha);
    }
}