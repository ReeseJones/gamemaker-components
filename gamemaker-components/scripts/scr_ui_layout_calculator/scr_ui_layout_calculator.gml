
///@param {Struct.ElementProperties} _element
function ui_calculate_layout(_element) {
    static elementQueue = ds_queue_create();
    ds_queue_clear(elementQueue);

    if(_element.calculatedSize.needsRecalculated) {
        ds_queue_enqueue(elementQueue, _element);
    }

    if(is_undefined(_element.parentNode)) {
        ui_size_root_to_window(_element);
    }

    while(!ds_queue_empty(elementQueue)) {
        var _current = ds_queue_dequeue(elementQueue);
        var _childrenCount = array_length(_current.childNodes);
        for(var i = 0; i < _childrenCount; i += 1) {
            var _child = _current.childNodes[i];
            if(_child.calculatedSize.needsRecalculated) {
                ds_queue_enqueue(elementQueue, _child);
            }
        }

        var _currentLayoutType = _current.sizeProperties.layout;
        var _layoutScript = ui_layout_manual;
        switch(_currentLayoutType) {
            case ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL:
                _layoutScript = ui_layout_flex_horizontal;
            break;
            case ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL:
                _layoutScript = ui_layout_flex_vertical;
            break;
        }

        _layoutScript(_current);
        show_debug_message($"Recalculated ${_current} {object_get_name(_current.object_index)} {_current.nodeDepth}");
    }
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