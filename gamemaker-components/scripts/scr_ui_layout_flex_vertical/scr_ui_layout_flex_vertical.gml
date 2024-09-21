///@param {Struct.ElementProperties} _node
function ui_layout_flex_vertical(_node) {
    var _parentSize = _node.calculatedSize;
    var _childOffset = _parentSize.childOffset;
    var _childCount = array_length(_node.childNodes);
    var _currentDistributableHeight = _parentSize.innerHeight;
    var _dynamicElements = [];
    _parentSize.contentSize = 0;

    _parentSize.needsRecalculated = false; 

    //TODO: Collect info on children size. Flex layout size will increase to accomodate children? Or save size vs required size?
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        _child.calculateSizeCallback(_child, _node);

        // If elements do not have a defined height they are flexible. (even with padding/border)
        if( is_undefined(_child.sizeProperties.height) || _child.calculatedSize.height == 0) {
            array_push(_dynamicElements, _child);
        } else {
            _currentDistributableHeight -= _child.calculatedSize.height;
            _parentSize.contentSize += _child.calculatedSize.height;
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
        _parentSize.contentSize += _distributedHeight;
    }

    var _justification = _node.sizeProperties.justifyContent;
    var _sizeDifference = _parentSize.innerHeight - _parentSize.contentSize;
    var _currentPos = _parentSize.position.top + _parentSize.border.top + _parentSize.padding.top + _childOffset.y;
    switch(_justification) {
        case LAYOUT_JUSTIFICATION.CENTER:
            _currentPos += _sizeDifference / 2;
        break;
        case LAYOUT_JUSTIFICATION.END:
            _currentPos += _sizeDifference;
        break;
        case LAYOUT_JUSTIFICATION.START:
        default:
        //Leave as is
        break;
    }

    var _left = _parentSize.position.left + _parentSize.border.left + _parentSize.padding.left + _childOffset.x;

    _childCount = array_length(_node.childNodes);
    for ( var i = 0; i < _childCount; i += 1 ) {
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