function flexpanel_debug_draw_node(_node, _depth = 0) {
    static colors = [c_red, c_aqua, c_green, c_yellow, c_teal, c_purple, c_olive, c_silver, c_maroon, c_lime];
    static colorCount = array_length(colors);
    draw_set_alpha(0.6);
    
    var _pos = flexpanel_node_layout_get_position(_node, false)
    var _name = flexpanel_node_get_name(_node);
    
    var _bottom = _pos.top + _pos.height;
    var _right = _pos.left + _pos.width;
    
    draw_set_color(colors[_depth % colorCount]);
    draw_rectangle(_pos.left, _pos.top, _right, _bottom, false);
    draw_set_color(c_black);
    draw_text(_pos.left, _pos.top, $"{_name}");

    var _childrenCount = flexpanel_node_get_num_children(_node);
    for(var i = 0; i < _childrenCount; i += 1 ) {
        var _childNode = flexpanel_node_get_child(_node, i);
        flexpanel_debug_draw_node(_childNode, _depth + 1);
    }
    

}