event_inherited();

if(is_defined(textDescription.text) && is_defined(calculatedSize.width) && is_defined(calculatedSize.height)) {
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
    draw_set_color(textDescription.color);
    draw_set_alpha(textDescription.alpha);
    draw_set_font(textDescription.font);
    draw_set_halign(textDescription.halign);
    draw_set_valign(textDescription.valign);
    
    if(is_defined(textDescription.text)) {
        sizeProperties.height = string_height_ext(textDescription.text, textDescription.lineSpacing, calculatedSize.innerWidth) 
                                 + sizeProperties.padding.top + sizeProperties.padding.bottom;
    }
    
    _xx = round(_xx);
    _yy = round(_yy);
    draw_text_ext(_xx, _yy, textDescription.text, textDescription.lineSpacing, calculatedSize.innerWidth);
}
