///@param {Struct.ElementProperties} _node
function ui_layout_manual(_node) {
    _node.calculatedSize.needsRecalculated = false;
    var _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        _child.calculateSizeCallback(_child, _node);
        ui_calculate_element_position(_child, _node);
    }
}
