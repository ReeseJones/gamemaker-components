///@param {real} _XOrigin
///@param {real} _YOrigin
///@param {Struct.ElementProperties} _node
function ui_element_draw(_XOrigin, _YOrigin, _node) {

    if(instance_exists(_node) && _node.visible) {
        with(_node) {
            if(!is_defined(calculatedSize.width) || !is_defined(calculatedSize.height)) { 
                break;
            }
            
            // Enable painting new stencil values to declare areas in bound for UI drawing
            if(enableStencil) {
                gpu_set_stencil_func(cmpfunc_always);
                gpu_set_stencil_ref(abs(_node.depth + 1000));
            }

            if (is_defined(sprite_index) && sprite_index > 0) {
                var _xx = calculatedSize.position.left - _XOrigin;
                var _yy = calculatedSize.position.top - _YOrigin;
                var _sprWidth = sprite_get_width(sprite_index);
                var _sprHeight = sprite_get_height(sprite_index);
                
                if(image_angle != 0) {
                    image_xscale = calculatedSize.width / _sprWidth;
                    image_yscale = calculatedSize.height / _sprHeight;
                } else {
                    image_xscale = calculatedSize.width / _sprWidth;
                    image_yscale = calculatedSize.height / _sprHeight;
                }

                var _scale = vector2d_inplace_rotate({ x: image_xscale, y: image_yscale}, image_angle);

                var _color = mouseIsOver ? c_red : image_blend;
                draw_sprite_ext(sprite_index, 0, _xx + ceil(sprite_xoffset),  _yy + ceil(sprite_yoffset), abs(_scale.x), abs(_scale.y), image_angle, _color, image_alpha);
            }

            // After painting in the new stencil values, only draw to matching stencil areas
            if(enableStencil) {
                gpu_set_stencil_func(cmpfunc_equal);
            }
        }
    }

    ui_render_children(_XOrigin, _YOrigin, _node);

    //And finally revert to not limiting the stencil drawing
    if(_node.enableStencil) {
        gpu_set_stencil_ref(cmpfunc_always);
    }
}