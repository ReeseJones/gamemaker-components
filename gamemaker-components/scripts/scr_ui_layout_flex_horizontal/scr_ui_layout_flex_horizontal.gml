///@param {Struct.ElementProperties} _node
function ui_layout_flex_horizontal(_node) {
    var _childCount = array_length(_node.childNodes);
    var _currentDistributableWidth = _node.calculatedSize.innerWidth;
    var _dynamicElements = [];
    //TODO: Collect info on children size. Flex layout size will increase to accomodate children? Or save size vs required size?
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        ui_calculate_element_size(_child, _node);

        // TODO: consider borders and padding?
        if( is_undefined(_child.sizeProperties.width) || _child.calculatedSize.width == 0) {
            array_push(_dynamicElements, _child);
        } else {
            _currentDistributableWidth -= _child.calculatedSize.width;
        }
    }

    _currentDistributableWidth = max(0, _currentDistributableWidth);
    _childCount = array_length(_dynamicElements);
    var _distributedWidth = _currentDistributableWidth / _childCount;
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _dynamicElements[i];
        var _childCalcSize = _child.calculatedSize;

        // TODO: consider borders and padding? Borders and padding need to be incorperated.
        _childCalcSize.width = _distributedWidth
        _childCalcSize.innerWidth = _distributedWidth;
    }

    var _parentSize = _node.calculatedSize;
    var _currentPos = _parentSize.position.left + _parentSize.border.left + _parentSize.padding.left;
    var _top = _parentSize.position.top + _parentSize.border.top + _parentSize.padding.top;
    _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        var _positionDest = _child.calculatedSize.position;
        _positionDest.top = _top;
        _positionDest.left = _currentPos;
        _positionDest.bottom = _top + _child.calculatedSize.height;
        _positionDest.right = _positionDest.left + _child.calculatedSize.width;
        _currentPos += _child.calculatedSize.width;
    }
}