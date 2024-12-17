function flexpanel_debug_draw_node(_node) {
    var _childrenCount = flexpanel_node_get_num_children(_node);
    
        
    for(var i = 0; i < _childrenCount; i += 1 ) {
        var _childNode = flexpanel_node_get_child(_node, i);
        flexpanel_debug_draw_node(_childNode);
    }
    
    draw_set_alpha(1);
    
    var _pos = flexpanel_node_layout_get_position(_node, false)
    var _name = flexpanel_node_get_name(_node);
    draw_set_color(c_green);
    draw_rectangle(_pos.left, _pos.top, _pos.left + _pos.width, _pos.top + _pos.height, true);
    
    draw_set_color(c_orange);
    var _paddingTop = _pos.top + _pos.paddingTop;
    var _paddingBottom = _pos.top + _pos.height - _pos.paddingBottom;
    var _paddingLeft = _pos.left + _pos.paddingLeft;
    var _paddingRight = _pos.left + _pos.width - _pos.paddingRight;
    draw_rectangle(_paddingLeft, _paddingTop, _paddingRight, _paddingBottom, true);
    
    draw_text(_paddingLeft, _paddingTop, $"{_name} - hadOverflow: {_pos.hadOverflow ? "true" : "false"}");

}