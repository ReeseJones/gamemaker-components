function ui_button_draw() {
    if( mouseIsOver ) {
        draw_set_color(buttonHoverColor);
    } else {
        draw_set_color(buttonColor);
    }

    var _left = x - width / 2;
    var _bottom = y - height / 2;
    var _right = x + width / 2;
    var _top =  y + height / 2;


    draw_button(_left, _bottom, _right, _top, !mouseIsOver || !mouse_check_button(mb_left));

    if( mouseIsOver ) {
        draw_set_color(textHoverColor);
    } else {
        draw_set_color(textColor);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_ext(x, y, text, 8, width);

}