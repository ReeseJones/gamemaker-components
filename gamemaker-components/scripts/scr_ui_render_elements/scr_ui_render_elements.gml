///@param {Struct.UIElement} _root
function ui_render_elements(_root) {
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
        
        if(struct_exists(_node, "draw")) {
            _node.draw();
        }
    }
    
    ds_queue_destroy(_queue);
}