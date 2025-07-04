function ui_make_button_text(_buttonText, _onClick, _name = "button") {
    var _buttonTextElement = new UIElement({
        name: _name + "Text"
     });
    var _button = new UIButton({
        name: _name,
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "stretch",
        //padding: 32,
        //margin: 32,
    });
    _button.append(_buttonTextElement);
    
    _buttonTextElement.textDescription.font = font_ui_small;
    _buttonTextElement.textDescription.halign = fa_center;
    _buttonTextElement.textDescription.valign = fa_middle;
    _buttonTextElement.setText(_buttonText, TEXT_SIZE_METHOD.EXACT);
    _buttonTextElement.interceptPointerEvents = false;

    _button.setPadding(flexpanel_edge.all_edges, 16);
    _button.spriteIndex = spr_menu_button_default;
    
    if(is_callable(_onClick)) {
        event_add_listener(_button, EVENT_CLICKED, _onClick);
    }

    return _button;
}

function ui_make_button_sprite(_foregroundSprite, _backgroundSprite, _onClick, _padding, _name = "button") {
    var _foreground = new UIElement({
        name: _name + "Icon",
    });
    _foreground.interceptPointerEvents = false;
    if(sprite_exists(_foregroundSprite)) {
        var _width = sprite_get_width(_foregroundSprite);
        var _height = sprite_get_height(_foregroundSprite);
        var _aspect = _width / _height;
        _foreground.spriteIndex = _foregroundSprite;
        _foreground.setWidth(_width, flexpanel_unit.point);
        _foreground.setAspectRatio(_aspect);
    }

    var _button = new UIButton({
        name: _name,
        padding: _padding,
        justifyContent: "center",
        alignItems: "stretch",
    });
    _button.append(_foreground);
    _button.setPadding(flexpanel_edge.all_edges, _padding);
    if ( sprite_exists(_backgroundSprite ) ) {
        _button.spriteIndex = _backgroundSprite;
    }

    if(is_callable(_onClick)) {
        event_add_listener(_button, EVENT_CLICKED, _onClick);
    }

    return _button;
}