///@param {Struct.ElementProperties} _node
function ui_size_root_to_window(_node) {
    var _rootWidth = display_get_gui_width();
    var _rootHeight = display_get_gui_height();

    _node.calculatedSize.height = _rootHeight;
    _node.calculatedSize.width = _rootWidth;
    _node.calculatedSize.innerHeight = _rootHeight;
    _node.calculatedSize.innerWidth = _rootWidth;
    _node.calculatedSize.border = global.boxZero;
    _node.calculatedSize.padding = global.boxZero;
    _node.calculatedSize.position.left = 0;
    _node.calculatedSize.position.right = _rootWidth;
    _node.calculatedSize.position.top = 0;
    _node.calculatedSize.position.bottom = _rootHeight;
}