///@param {Struct.ElementProperties} _node
function ui_layout_flex_horizontal(_node) {
    var _parentSize = _node.calculatedSize;
    var _childCount = array_length(_node.childNodes);
    var _currentDistributableWidth = _parentSize.innerWidth;
    var _dynamicElements = [];

    _parentSize.needsRecalculated = false;

    //TODO: Collect info on children size. Flex layout size will increase to accomodate children? Or save size vs required size?
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        _child.calculateSizeCallback(_child, _node);

        // If elements do not have a defined width they are flexible. (even with padding/border)
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
        _childCalcSize.width = _distributedWidth;
        ui_calculate_inner_width(_childCalcSize);
    }

    var _currentPos = _parentSize.position.left + _parentSize.border.left + _parentSize.padding.left;
    var _top = _parentSize.position.top + _parentSize.border.top + _parentSize.padding.top;
    _childCount = array_length(_node.childNodes);
    for( var i = 0; i < _childCount; i += 1 ) {
        var _child = _node.childNodes[i];
        var _childSize = _child.calculatedSize;
        var _positionDest = _child.calculatedSize.position;
        // update vertical/size position
        var _alignment = _node.sizeProperties.alignment;
        switch(_alignment) {
            case LAYOUT_ALIGNMENT.CENTER:
                var _centerOffset = (_parentSize.innerHeight - _childSize.height) / 2;
                _positionDest.top = _top + _centerOffset;
                _positionDest.bottom = _positionDest.top + _childSize.height;
            break;
            case LAYOUT_ALIGNMENT.START:
                _positionDest.top = _top;
                _positionDest.bottom = _positionDest.top + _childSize.height;
            break;
            case LAYOUT_ALIGNMENT.END:
                var _endOffset = _parentSize.innerHeight - _childSize.height;
                _positionDest.top = _top + _endOffset;
                _positionDest.bottom = _positionDest.top + _childSize.height;
            break;
            case LAYOUT_ALIGNMENT.STRETCH:
            default:
                _positionDest.top = _top;
                _positionDest.bottom = _top + _parentSize.innerHeight;
                _childSize.height = _parentSize.innerHeight;
                ui_calculate_inner_height(_childSize);
            break;
        }

        _positionDest.left = _currentPos;
        _positionDest.right = _positionDest.left + _child.calculatedSize.width;

        _currentPos += _child.calculatedSize.width;
    }
}