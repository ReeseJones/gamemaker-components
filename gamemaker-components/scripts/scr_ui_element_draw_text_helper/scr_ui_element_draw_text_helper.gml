///@self UIElement
function ui_element_draw_text_helper() {
    if( !is_string(textDescription.text)) {
        return;
    }

    var _xx = 0;
    var _yy = 0;
    switch(textDescription.halign) {
        case fa_right:
            _xx = right;
        break;
        case fa_center:
            _xx = (left + right) / 2;
            break;
        case fa_left:
        default:
            _xx = left;
            break;
    }
    switch(textDescription.valign) {
        case fa_bottom:
            _yy = bottom;
        break;
        case fa_middle:
            _yy = (top + bottom) / 2;
            break;
        case fa_top:
        default:
            _yy = top;
            break;
    }

    draw_set_color(mouseIsOver ? c_white : textDescription.color);
    draw_set_alpha(textDescription.alpha);
    draw_set_font(textDescription.font);
    draw_set_halign(textDescription.halign);
    draw_set_valign(textDescription.valign);

    _xx = round(_xx);
    _yy = round(_yy);
    draw_text_ext(_xx, _yy, textDescription.text, textDescription.lineSpacing, width);

}