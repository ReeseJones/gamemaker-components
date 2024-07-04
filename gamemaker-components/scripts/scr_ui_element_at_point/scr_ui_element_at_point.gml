///@param {real} _x
///@param {real} _y
///@param {Struct.ElementProperties} _node
///@returns {Struct.ElementProperties}
function ui_element_at_point(_x, _y, _node) {
    var _nodePos = _node.calculatedSize.position;
    var _childCount = array_length(_node.childNodes)
    var _pointInNode = point_in_rectangle(_x, _y, _nodePos.left, _nodePos.top, _nodePos.right, _nodePos.bottom);

    if(!_pointInNode) {
        return undefined;
    }
    var _currentCollides = undefined;
    if(_node.sizeProperties.collides) {
        _currentCollides = _node;
    }

    for(var i = 0; i < _childCount; i += 1) {
        var _child = _node.childNodes[i];
        var _childCollides = ui_element_at_point(_x, _y, _child);
        if(is_defined(_childCollides)) {
            _currentCollides = _childCollides;
            break;
        }
    }

    return _currentCollides;
}