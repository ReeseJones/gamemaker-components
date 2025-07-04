///@param {Struct} _flexpanelStyle
function UIButton(_flexpanelStyle) : UIElement(_flexpanelStyle) constructor {

    spriteIndex = spr_menu_button_default;
    
    static draw = function() {
        var _col = c_white;
        var _alpha = 1;
        if(mouseIsOver) {
            _col = merge_color(c_white, c_black, 0.2);
        }

        if(spriteIndex != undefined) {
            draw_sprite_stretched_ext(spriteIndex, 0, left, top, width, height, _col, _alpha);
        }

        ui_element_draw_text_helper();
    }
}