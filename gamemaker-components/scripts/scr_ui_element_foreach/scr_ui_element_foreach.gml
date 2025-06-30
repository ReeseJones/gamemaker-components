///@description depth first node taversal. calls callback on all nodes, starting with leaves and working its way up.
///@param {Struct.UIElement} _uiElement
///@param {function} _callback
///@param {bool} _includeRoot
function ui_element_foreach(_uiElement, _callback, _includeRoot = false) {
    var _childLength = array_length(_uiElement.childNodes); // flexpanel_node_get_num_children(_uiElement.flexNode);
    for(var i = 0; i < _childLength; i += 1) {
        var _child = _uiElement.childNodes[i];
        ui_element_foreach(_child, _callback, true);
    }
    if(_includeRoot) {
        _callback(_uiElement);
    }
}