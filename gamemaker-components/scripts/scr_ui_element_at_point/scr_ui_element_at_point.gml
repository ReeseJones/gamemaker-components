///@param {real} _x
///@param {real} _y
///@param {Struct.ElementProperties} _node
///@returns {Struct.ElementProperties}
function ui_element_at_point(_x, _y, _node) {

    var _childCount = array_length(_node.childNodes)
    for(var i = 0; i < _childCount; i += 1) {
        var _child = _node.childNodes[i];
        var _childPos = _child.calculatedSize.position;
        if( point_in_rectangle(_x, _y, _childPos.left, _childPos.top, _childPos.right, _childPos.bottom) ) {
            return ui_element_at_point(_x, _y, _child);
        }
    }

    return _node;
}