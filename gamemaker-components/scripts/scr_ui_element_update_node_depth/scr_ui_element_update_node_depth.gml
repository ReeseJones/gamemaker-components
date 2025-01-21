///@param {Struct.UIElement} _uiElement
function ui_element_update_node_depth(_uiElement) {

    var _parent = _uiElement.parent();
    if(is_undefined(_parent)) {
        _uiElement.nodeDepth = 0;
    } else {
        _uiElement.nodeDepth = _parent.nodeDepth + 1;
    }
    
    var _childCount = flexpanel_node_get_num_children(_uiElement.flexNode);
    for(var i = 0; i < _childCount; i += 1) {
        var _childNode = flexpanel_node_get_child(_uiElement.flexNode, i);
        var _childUIElement = flexpanel_node_get_data(_childNode);
        ui_element_update_node_depth(_childUIElement);
    }
}