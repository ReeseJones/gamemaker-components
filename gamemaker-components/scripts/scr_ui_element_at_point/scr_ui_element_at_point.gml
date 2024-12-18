///@param {real} _x
///@param {real} _y
///@param {Struct.UIElement} _node
///@returns {Struct.UIElement}
function ui_element_at_point(_x, _y, _node) {
    var _pointInNode = point_in_rectangle(_x, _y, _node.left, _node.top, _node.right, _node.bottom);

    if(!_pointInNode) {
        return undefined;
    }
    
    var _currentCollides = undefined;
    if(_node.interceptPointerEvents) {
        _currentCollides = _node;
    }
    
    
    var _childCount = flexpanel_node_get_num_children(_node.flexNode);
    for(var i = 0; i < _childCount; i += 1) {
        var _child = flexpanel_node_get_child(_node.flexNode, i);
        var _element = flexpanel_node_get_data(_child);
        var _childCollides = ui_element_at_point(_x, _y, _element);
        if(is_defined(_childCollides)) {
            _currentCollides = _childCollides;
            break;
        }
    }

    return _currentCollides;
}