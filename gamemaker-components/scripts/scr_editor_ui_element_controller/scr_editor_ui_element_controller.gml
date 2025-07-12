///@param {Struct.UIElement} _element
function EditorUiElementController(_element) constructor  {
    
    var _icon = spr_icon_responsive_layout;

    if(is_instanceof( _element, UIScrollContainer)) {
        _icon = spr_icon_list;
    } else if(is_instanceof( _element, UIButton)) {
        _icon = spr_icon_buttons_alt;
    } else if(is_instanceof(_element, UITextInput)) {
        _icon = spr_icon_terminal;
    }


    targetElement = _element;
    listViewElement = editor_ui_make_element_order_indicator(_element.getNodeName(), _icon);

}

function editor_ui_make_element_order_indicator(_name, _icon) {
    var _elementName = $"{_name}OrderIndicator";
    var _placeHolder = function(){show_debug_message("element_order_indicator clicked.")};
    var _ui_element_order_indicator = ui_make_button_text(_name, _placeHolder, _elementName);
    
    var _iconElement = new UIElement({
        name: _elementName + "Icon",
    });
    _iconElement.interceptPointerEvents = false;
    var _width = sprite_get_width(_icon);
    var _height = sprite_get_height(_icon);
    var _aspect = _width / _height;
    _iconElement.spriteIndex = _icon;
    _iconElement.setWidth(_width, flexpanel_unit.point);
    _iconElement.setAspectRatio(_aspect);

    _ui_element_order_indicator.prepend( _iconElement );


    return _ui_element_order_indicator;
}