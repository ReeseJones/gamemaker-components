///@param {Struct.ElementProperties} _node
function ui_layout_manual(_node) {
    var _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        ui_calculate_element_size(_child, _node);
        ui_calculate_element_position(_child, _node);
    }
}
