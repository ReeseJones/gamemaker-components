///@param {real} _XOrigin X origin
///@param {real} _YOrigin Y Origin
///@param {Struct.ElementProperties} _node
function ui_render_root(_XOrigin, _YOrigin, _node) {
    _node.drawElement(_XOrigin, _YOrigin, _node)
}