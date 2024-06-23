///@param {Struct.ElementProperties} _node
function ui_layout_flex_vertical(_node) {
    var _childCount = array_length(_node.childNodes);
    var _currentDistributableHeight = _node.calculatedSize.innerHeight;
    var _dynamicElements = [];
    //TODO: Collect info on children size. Flex layout size will increase to accomodate children? Or save size vs required size?
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        ui_calculate_element_size(_child, _node);

        // If elements do not have a defined height they are flexible. (even with padding/border)
        if( is_undefined(_child.sizeProperties.height) || _child.calculatedSize.height == 0) {
            array_push(_dynamicElements, _child);
        } else {
            _currentDistributableHeight -= _child.calculatedSize.height;
        }
    }

    _currentDistributableHeight = max(0, _currentDistributableHeight);
    _childCount = array_length(_dynamicElements);
    var _distributedHeight = _currentDistributableHeight / _childCount;
    for ( var i = 0; i < _childCount; i += 1 ) {
        var _child = _dynamicElements[i];
        var _childCalcSize = _child.calculatedSize;
        _childCalcSize.height = _distributedHeight;
        ui_calculate_inner_height(_childCalcSize);
    }

    var _parentSize = _node.calculatedSize;
    var _top = _parentSize.position.top + _parentSize.border.top + _parentSize.padding.top;
    var _left = _parentSize.position.left + _parentSize.border.left + _parentSize.padding.left;
    var _currentPos = _top;
    _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        var _childSize = _child.calculatedSize;
        var _positionDest = _child.calculatedSize.position;
        // update horizontal/size position
        var _alignment = _node.sizeProperties.alignment;
        switch(_alignment) {
            case LAYOUT_ALIGNMENT.CENTER:
                var _centerOffset = (_parentSize.innerWidth - _childSize.width) / 2;
                _positionDest.left = _left + _centerOffset;
                _positionDest.right = _positionDest.left + _childSize.width;
            break;
            case LAYOUT_ALIGNMENT.START:
                _positionDest.left = _left;
                _positionDest.right = _positionDest.left + _childSize.width;
            break;
            case LAYOUT_ALIGNMENT.END:
                var _endOffset = _parentSize.innerWidth - _childSize.width;
                _positionDest.left = _left + _endOffset;
                _positionDest.right = _positionDest.left + _childSize.width;
            break;
            case LAYOUT_ALIGNMENT.STRETCH:
            default:
                _positionDest.left = _left;
                _positionDest.right = _left + _parentSize.innerWidth;
                _childSize.width = _parentSize.innerWidth;
                ui_calculate_inner_width(_childSize);
            break;
        }

        _positionDest.top = _currentPos;
        _positionDest.bottom = _positionDest.top + _child.calculatedSize.height;
        _currentPos += _child.calculatedSize.height;
    }
}