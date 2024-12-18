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
    }
    
    ds_queue_destroy(_queue);
}

