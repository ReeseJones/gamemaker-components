
///@param {Struct.ElementProperties} _element
function ui_calculate_layout(_element) {
    static elementQueue = ds_queue_create();
    ds_queue_clear(elementQueue);

    ds_queue_enqueue(elementQueue, _element);

    while(!ds_queue_empty(elementQueue)) {
        var _current = ds_queue_dequeue(elementQueue);
        var _childrenCount = array_length(_current.childNodes);
        for(var i = 0; i < _childrenCount; i += 1) {
            var _child = _current.childNodes[i];
            ds_queue_enqueue(elementQueue, _child);
        }
        ui_calculate_element(_current, _current.parentNode)
    }
}

///@param {Struct.ElementProperties} _node
///@param {Struct.ElementProperties} _parentNode
function ui_calculate_element(_node, _parentNode) {
    if(is_undefined(_parentNode)) {
        ui_size_root_to_window(_node);
    } else {
         ui_calculate_element_size(_node, _parentNode);
    }

    if(is_defined(_parentNode)
       && _parentNode.sizeProperties.layout == ELEMENT_LAYOUT_TYPE.MANUAL) {
        ui_calculate_element_position(_node, _parentNode);
     } else {
         var _currentLayoutType = _node.sizeProperties.layout;
         switch(_currentLayoutType) {
             case ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL:
             case ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL:
         }
     }
}

///@param {real} _dimension
///@param {real} _parentDimension
///@param {real} _begin
///@param {real} _end
function ui_calculate_dimension(_dimension, _parentDimension, _begin = undefined, _end = undefined) {
    var _parentIsReal = is_real(_parentDimension);
    if( is_real(_dimension) ) {
        return number_in_range(_dimension, -1, 1) && _parentIsReal
            ? _dimension * _parentDimension
            : _dimension;
    }

    if( is_real(_begin) && is_real(_end) && _parentIsReal) {
        _begin = number_in_range(_begin, -1, 1)
            ? _begin * _parentDimension
            : _begin;
        _end = number_in_range(_end, -1, 1)
            ? _end * _parentDimension
            : _end;
        return max(0, _parentDimension - _begin - _end);
    }

    return 0;
}

///@param {Struct.ElementProperties} _node
///@param {Struct.ElementProperties} _parentNode
function ui_calculate_element_size(_node, _parentNode) {
    var _parentSize = _parentNode.calculatedSize;
    var _nodeDest = _node.calculatedSize;
    var _nodeSrc = _node.sizeProperties;

    var _borderDest = _node.calculatedSize.border;
    var _borderSrc = _node.sizeProperties.border;

    var _paddingDest = _node.calculatedSize.padding;
    var _paddingSrc = _node.sizeProperties.padding;

    var _positionSrc = _node.sizeProperties.position;

    _borderDest.bottom = ui_calculate_dimension(_borderSrc.bottom, _parentSize.innerHeight);
    _borderDest.top = ui_calculate_dimension(_borderSrc.top, _parentSize.innerHeight);
    _borderDest.left = ui_calculate_dimension(_borderSrc.left, _parentSize.innerWidth);
    _borderDest.right = ui_calculate_dimension(_borderSrc.right, _parentSize.innerWidth);

    _paddingDest.bottom = ui_calculate_dimension(_paddingSrc.bottom, _parentSize.innerHeight);
    _paddingDest.top = ui_calculate_dimension(_paddingSrc.top, _parentSize.innerHeight);
    _paddingDest.left = ui_calculate_dimension(_paddingSrc.left, _parentSize.innerWidth);
    _paddingDest.right = ui_calculate_dimension(_paddingSrc.right, _parentSize.innerWidth);
    
    // Calculate temp parent relative positions
    var _posBottom = ui_calculate_dimension(_positionSrc.bottom, _parentSize.innerHeight);
    var _posTop = ui_calculate_dimension(_positionSrc.top, _parentSize.innerHeight);
    var _posLeft = ui_calculate_dimension(_positionSrc.left, _parentSize.innerWidth);
    var _posRight = ui_calculate_dimension(_positionSrc.right, _parentSize.innerWidth);

    // Width and height is calculated from parents internalWidth and height, which if it has padding will be smaller than its nominal width;
    _nodeDest.width = ui_calculate_dimension(_nodeSrc.width, _parentSize.innerWidth, _posLeft, _posRight);
    _nodeDest.height = ui_calculate_dimension(_nodeSrc.height, _parentSize.innerHeight, _posTop, _posBottom);

    // Choose the larger, padding + border size or initial calculated size. generally should result in calcualted size
    // otherwise that means the border and padding are taking up 100% or more of the desired space.
    _nodeDest.width = max(_nodeDest.width, _borderDest.left + _borderDest.right + _paddingDest.left + _paddingDest.right);
    _nodeDest.height = max(_nodeDest.height, _borderDest.top + _borderDest.bottom + _paddingDest.top + _paddingDest.bottom);

    _nodeDest.innerWidth = _nodeDest.width - _paddingDest.left - _paddingDest.right - _borderDest.left - _borderDest.right;
    _nodeDest.innerHeight = _nodeDest.height - _paddingDest.top - _paddingDest.bottom - _borderDest.top - _borderDest.bottom;
}

///@description Caclulates the position of an element manually specified by user. MUST calculate parent and size first!
///@param {Struct.ElementProperties} _node
///@param {Struct.ElementProperties} _parentNode
function ui_calculate_element_position(_node, _parentNode) {
    var _parentSize = _parentNode.calculatedSize;
    var _nodeDest = _node.calculatedSize;

    var _positionDest = _node.calculatedSize.position;
    var _positionSrc = _node.sizeProperties.position;

    var _posTop = ui_calculate_dimension(_positionSrc.top, _parentSize.innerHeight);
    var _posLeft = ui_calculate_dimension(_positionSrc.left, _parentSize.innerWidth);

    _positionDest.top = _posTop + _parentSize.position.top + _parentSize.border.top + _parentSize.padding.top;
    _positionDest.left = _posLeft + _parentSize.position.left + _parentSize.border.left + _parentSize.padding.left;
    _positionDest.bottom = _positionDest.top + _nodeDest.height;
    _positionDest.right = _positionDest.left + _nodeDest.width;
}