///@param {real} _XOrigin
///@param {real} _YOrigin
///@param {Struct.ElementProperties} _node
function ui_text_draw(_XOrigin, _YOrigin, _node) {

    if(instance_exists(_node) && _node.visible) {
        with(_node) {
            if(!is_defined(calculatedSize.width) || !is_defined(calculatedSize.height)) {
                break;
            }

            if (is_defined(sprite_index) && sprite_index > 0) {
                var _xx = calculatedSize.position.left - _XOrigin;
                var _yy = calculatedSize.position.top - _YOrigin;
                var _widthScale = calculatedSize.width / sprite_get_width(sprite_index);
                var _heightScale = calculatedSize.height / sprite_get_height(sprite_index);
                var _color = mouseIsOver ? c_red : image_blend;
 
                draw_sprite_ext(sprite_index, 0, _xx,  _yy, _widthScale, _heightScale, image_angle, _color, image_alpha);
            }

            if(is_defined(textDescription.text)) {
                var _xx = 0;
                var _yy = 0;
                switch(textDescription.halign) {
                    case fa_right:
                        _xx = calculatedSize.position.right - calculatedSize.border.right - calculatedSize.padding.right;
                    break;
                    case fa_center:
                        _xx = (calculatedSize.position.left + calculatedSize.position.right) / 2;
                        break;
                    case fa_left:
                    default:
                        _xx = calculatedSize.position.left + calculatedSize.border.left + calculatedSize.padding.left;
                        break;
                }
                switch(textDescription.valign) {
                    case fa_bottom:
                        _yy = calculatedSize.position.bottom - calculatedSize.border.bottom - calculatedSize.padding.bottom;
                    break;
                    case fa_middle:
                        _yy = (calculatedSize.position.top + calculatedSize.position.bottom) / 2;
                        break;
                    case fa_top:
                    default:
                        _yy = calculatedSize.position.top + calculatedSize.border.top + calculatedSize.padding.top;
                        break;
                }
                draw_set_color(mouseIsOver ? c_white : textDescription.color);
                draw_set_alpha(textDescription.alpha);
                draw_set_font(textDescription.font);
                draw_set_halign(textDescription.halign);
                draw_set_valign(textDescription.valign);
                

                _xx = round(_xx);
                _yy = round(_yy);
                draw_text_ext(_xx, _yy, textDescription.text, textDescription.lineSpacing, calculatedSize.innerWidth);
            }
        }
    }

    //ui_render_children(_XOrigin, _YOrigin, _node);
}