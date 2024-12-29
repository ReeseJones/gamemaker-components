/*
///depth first
///@param {Struct.UIElement} _root
function ui_calculate_element_positions(_root) {
    var _queue = ds_queue_create();
    ds_queue_enqueue(_queue, _root);
    
    while( !ds_queue_empty(_queue) ) {
        var _node = ds_queue_dequeue(_queue);
        
        // Queue child nodes for rendering.
        var _flexNode = _node.flexNode;
        var _children = flexpanel_node_get_num_children(_flexNode);
        for(var i = 0; i < _children; i += 1) {
            var _child = flexpanel_node_get_child(_flexNode, i);
            var _data = flexpanel_node_get_data(_child);
            ds_queue_enqueue(_queue, _data);
        }
        
        var _pos = flexpanel_node_layout_get_position(_flexNode, false);
        var _right = _pos.left + _pos.width;
        var _bottom = _pos.top + _pos.height;
        
        _node.left = _pos.left;
        _node.right = _right;
        _node.top = _pos.top;
        _node.bottom = _bottom;
        _node.width = _pos.width;
        _node.height = _pos.height;
        _node.hadOverflow = _pos.hadOverflow;
    }
    
    ds_queue_destroy(_queue);
}
*/

///@param {Struct.UIElement} _root
function ui_calculate_element_positions(_root) {
    var _childrenNum = flexpanel_node_get_num_children(_root.flexNode);
    var _pos = flexpanel_node_layout_get_position(_root.flexNode, false);
    var _right = _pos.left + _pos.width;
    var _bottom = _pos.top + _pos.height;
    
    _root.left = _pos.left;
    _root.right = _right;
    _root.top = _pos.top;
    _root.bottom = _bottom;
    _root.width = _pos.width;
    _root.height = _pos.height;
    _root.hadOverflow = _pos.hadOverflow;
    
    //if(_root.hadOverflow) {
    //    show_debug_message($"{_root} had overflow");
    //}
    
    var _overflowLeft = _root.left;
    var _overflowRight = _root.right;
    var _overflowTop = _root.top;
    var _overflowBottom = _root.bottom;
    
    for(var i = 0; i < _childrenNum; i += 1) {
        var _childNode = flexpanel_node_get_child(_root.flexNode, i);
        var _childElement = flexpanel_node_get_data(_childNode);
        ui_calculate_element_positions(_childElement);
        _overflowLeft = min(_childElement.left, _overflowLeft);
        _overflowRight = max(_childElement.right, _overflowRight);
        _overflowTop = min(_childElement.top, _overflowTop);
        _overflowBottom = max(_childElement.bottom, _overflowBottom);
    }
    
    _root.contentWidth = _overflowRight - _overflowLeft;
    _root.contentHeight = _overflowBottom - _overflowTop;
}

/*
///@param {Struct.UIElement} _root
function ui_calculate_element_positions(_root) {
    
    while( !ds_queue_empty(_queue) ) {
        var _node = ds_queue_dequeue(_queue);
        
        // Queue child nodes for rendering.
        var _flexNode = _node.flexNode;
        var _children = flexpanel_node_get_num_children(_flexNode);
        for(var i = 0; i < _children; i += 1) {
            var _child = flexpanel_node_get_child(_flexNode, i);
            var _data = flexpanel_node_get_data(_child);
            ds_queue_enqueue(_queue, _data);
        }
        
        var _pos = flexpanel_node_layout_get_position(_flexNode, false);
        var _right = _pos.left + _pos.width;
        var _bottom = _pos.top + _pos.height;
        
        _node.left = _pos.left;
        _node.right = _right;
        _node.top = _pos.top;
        _node.bottom = _bottom;
        _node.width = _pos.width;
        _node.height = _pos.height;
        _node.hadOverflow = _pos.hadOverflow;
    }
    
    ds_queue_destroy(_queue);
}


*/