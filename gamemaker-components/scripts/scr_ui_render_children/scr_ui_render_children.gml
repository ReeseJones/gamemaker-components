///@param {real} _XOrigin X Origin
///@param {real} _YOrigin Y Origin
///@param {Struct.ElementProperties} _node
function ui_render_children(_XOrigin, _YOrigin, _node) {
    var _childCount = array_length(_node.childNodes);
    for(var i = 0; i < _childCount; i += 1) {
        var _child = _node.childNodes[i];
        ui_render_root(_XOrigin, _YOrigin, _child);
    }
}