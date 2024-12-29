/*
///Breadth first
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
            if(is_callable(_node.draw)) {
                _node.draw();
            } else {
                throw "node draw was not callable.";
            }
            
        }
    }
    
    ds_queue_destroy(_queue);
}
*/

//depth first
///@param {Struct.UIElement} _root
function ui_render_elements(_root) {
    var _childrenNum = flexpanel_node_get_num_children(_root.flexNode);
    
    if(struct_exists(_root, "draw")) {
        if(is_callable(_root.draw)) {
            _root.draw();
        } else {
            throw "node draw was not callable.";
        }
    }
    
    var _scissor = gpu_get_scissor();
    
    if(_root.hadOverflow) {
        var _width = _root.right - _root.left;
        var _height = _root.bottom - _root.top;
        gpu_set_scissor(_root.left, _root.top, _width, _height);
    }
    
    for(var i = 0; i < _childrenNum; i += 1) {
        var _childNode = flexpanel_node_get_child(_root.flexNode, i);
        var _childElement = flexpanel_node_get_data(_childNode);
        ui_render_elements(_childElement);
    }
    
    if(_root.hadOverflow) {
        gpu_set_scissor(_scissor);
    }
}
