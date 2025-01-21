///@param {Struct.UIElement} _uiElement
///@param {function} _callback
///@param {bool} _includeRoot
function ui_element_foreach_parent(_uiElement, _callback, _includeRoot = false) {
    if(_includeRoot) {
        _callback(_uiElement);
    }
    var _parent = _uiElement.parent();
    if(!is_undefined(_parent)) {
        ui_element_foreach_parent(_parent, _callback, true);
    }
}