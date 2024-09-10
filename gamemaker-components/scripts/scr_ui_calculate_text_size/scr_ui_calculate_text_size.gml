 ///@param {Struct.ElementProperties} _node
///@param {Struct.ElementProperties} _parentNode
function ui_calculate_text_size(_node, _parentNode) {
    var _parentSize = _parentNode.calculatedSize;
    var _childSize = _node.calculatedSize;
    var _nodeSrc = _node.sizeProperties;

    var _borderDest = _childSize.border;
    var _borderSrc = _nodeSrc.border;

    var _paddingDest = _childSize.padding;
    var _paddingSrc = _nodeSrc.padding;

    var _positionSrc = _nodeSrc.position;

    ui_calculate_box_dimensions(_borderDest, _borderSrc, _parentSize);
    ui_calculate_box_dimensions(_paddingDest, _paddingSrc, _parentSize);

    // Calculate temp parent relative positions
    var _posBottom = ui_calculate_edge_dimension(_positionSrc.bottom, _parentSize.innerHeight);
    var _posTop = ui_calculate_edge_dimension(_positionSrc.top, _parentSize.innerHeight);
    var _posLeft = ui_calculate_edge_dimension(_positionSrc.left, _parentSize.innerWidth);
    var _posRight = ui_calculate_edge_dimension(_positionSrc.right, _parentSize.innerWidth);

    // Width and height is calculated from parents internalWidth and height, which if it has padding will be smaller than its nominal width;
    _childSize.width = ui_calculate_dimension(_nodeSrc.width, _parentSize.innerWidth, _posLeft, _posRight);
    _childSize.width = max(_childSize.width, _borderDest.left + _borderDest.right + _paddingDest.left + _paddingDest.right);
    ui_calculate_inner_width(_childSize);

    var _edgeHeight = _borderDest.top + _borderDest.bottom + _paddingDest.top + _paddingDest.bottom;
    // Text controlled Height
    var _textDesc = _node.textDescription;
    if( is_string(_textDesc.text) ) {
        draw_set_font(_textDesc.font);
        draw_set_halign(_textDesc.halign);
        draw_set_valign(_textDesc.valign);
        _nodeSrc.height = string_height_ext(_textDesc.text, _textDesc.lineSpacing, _childSize.innerWidth) + _edgeHeight;
    }

    _childSize.height = ui_calculate_dimension(_nodeSrc.height, _parentSize.innerHeight, _posTop, _posBottom);
    _childSize.height = max(_childSize.height, _edgeHeight);
    ui_calculate_inner_height(_childSize);
}