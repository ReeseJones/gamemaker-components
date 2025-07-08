function UiMakeTextOptions() constructor {
    font = font_ui_small;
    halign = fa_center;
    valign = fa_middle;
    text = "";
    interceptPointerEvents = false;
    name = "";
    textSizeMethod = TEXT_SIZE_METHOD.EXACT;
}


///@param {Struct.UiMakeTextOptions} _options
function ui_make_text(_options) {
     var _textElement = new UIElement({});

    if( has(_options, "name") && string_valid(_options.name) ) {
        _textElement.setNodeName(_options.name);
    }

    if( has(_options, "font") && is_handle(_options.font) && font_exists(_options.font) ) {
        _textElement.textDescription.font = _options.font;
    }

    if( has(_options, "halign") && is_real(_options.halign) ) {
        _textElement.textDescription.halign = _options.halign;
    }

    if( has(_options, "valign") && is_real(_options.valign) ) {
        _textElement.textDescription.valign = _options.valign;
    }

    if( has(_options, "text") && is_string(_options.text) ) {
        var _sizeMethod = has(_options, "textSizeMethod") && is_real(_options.textSizeMethod) ? _options.textSizeMethod : TEXT_SIZE_METHOD.EXACT;
        _textElement.setText(_options.text, _sizeMethod);
    }

    if( has(_options, "interceptPointerEvents") && is_bool(_options.interceptPointerEvents)) {
        _textElement.interceptPointerEvents = _options.interceptPointerEvents;
    } else {
        _textElement.interceptPointerEvents = false;
    }

    return _textElement;
}