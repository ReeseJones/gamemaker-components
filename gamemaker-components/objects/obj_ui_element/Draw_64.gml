/// @description Insert description here
// You can write your code in this editor
if(is_defined(sprite_index) && sprite_index > 0 && is_defined(calculatedSize.width) && is_defined(calculatedSize.height)) {
    var _xx = calculatedSize.position.left;
    var _yy = calculatedSize.position.top;
    var _widthScale = calculatedSize.width / sprite_get_width(sprite_index);
    var _heightScale = calculatedSize.height / sprite_get_height(sprite_index);
    draw_sprite_ext(sprite_index, 0, _xx,  _yy, _widthScale, _heightScale, 0, image_blend, image_alpha);
}
