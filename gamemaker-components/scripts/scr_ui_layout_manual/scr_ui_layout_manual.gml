///@param {Struct.ElementProperties} _node
function ui_layout_manual(_node) {
    _node.calculatedSize.needsRecalculated = false;
    var _childOffset = _node.calculatedSize.childOffset;
    var _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        _child.calculateSizeCallback(_child, _node);
        ui_calculate_element_position(_child, _node);
        var _pos = _child.calculatedSize.position;
        _pos.left += _childOffset.x;
        _pos.top += _childOffset.y;
        _pos.right += _childOffset.x;
        _pos.bottom += _childOffset.y;
    }
}
