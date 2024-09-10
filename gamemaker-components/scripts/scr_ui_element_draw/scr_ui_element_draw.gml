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
                var _widthScale = calculatedSize.width / sprite_get_width(sprite_index);
                var _heightScale = calculatedSize.height / sprite_get_height(sprite_index);
                var _color = mouseIsOver ? c_red : image_blend;
                draw_sprite_ext(sprite_index, 0, _xx,  _yy, _widthScale, _heightScale, image_angle, _color, image_alpha);
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