///@description depth first node taversal. calls callback on all nodes
///@param {Struct.UIElement} _uiElement
///@param {function} _callback
///@param {bool} _includeRoot
function ui_element_foreach(_uiElement, _callback, _includeRoot = false) {
    var _childLength = flexpanel_node_get_num_children(_uiElement.flexNode);
    for(var i = 0; i < _childLength; i += 1) {
        var _child = flexpanel_node_get_child(_uiElement.flexNode, i);
        var _childEl = flexpanel_node_get_data(_child);
        ui_element_foreach(_childEl, _callback, true);
    }
    if(_includeRoot) {
        _callback(_uiElement);
    }
}