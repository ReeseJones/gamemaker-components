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

    _borderDest.bottom = ui_calculate_edge_dimension(_borderSrc.bottom, _parentSize.innerHeight);
    _borderDest.top = ui_calculate_edge_dimension(_borderSrc.top, _parentSize.innerHeight);
    _borderDest.left = ui_calculate_edge_dimension(_borderSrc.left, _parentSize.innerWidth);
    _borderDest.right = ui_calculate_edge_dimension(_borderSrc.right, _parentSize.innerWidth);

    _paddingDest.bottom = ui_calculate_edge_dimension(_paddingSrc.bottom, _parentSize.innerHeight);
    _paddingDest.top = ui_calculate_edge_dimension(_paddingSrc.top, _parentSize.innerHeight);
    _paddingDest.left = ui_calculate_edge_dimension(_paddingSrc.left, _parentSize.innerWidth);
    _paddingDest.right = ui_calculate_edge_dimension(_paddingSrc.right, _parentSize.innerWidth);

    // Calculate temp parent relative positions
    var _posBottom = ui_calculate_edge_dimension(_positionSrc.bottom, _parentSize.innerHeight);
    var _posTop = ui_calculate_edge_dimension(_positionSrc.top, _parentSize.innerHeight);
    var _posLeft = ui_calculate_edge_dimension(_positionSrc.left, _parentSize.innerWidth);
    var _posRight = ui_calculate_edge_dimension(_positionSrc.right, _parentSize.innerWidth);

    // Width and height is calculated from parents internalWidth and height, which if it has padding will be smaller than its nominal width;
    _nodeDest.width = ui_calculate_dimension(_nodeSrc.width, _parentSize.innerWidth, _posLeft, _posRight);
    _nodeDest.height = ui_calculate_dimension(_nodeSrc.height, _parentSize.innerHeight, _posTop, _posBottom);

    // Choose the larger, padding + border size or initial calculated size. generally should result in calcualted size
    // otherwise that means the border and padding are taking up 100% or more of the desired space.
    _nodeDest.width = max(_nodeDest.width, _borderDest.left + _borderDest.right + _paddingDest.left + _paddingDest.right);
    _nodeDest.height = max(_nodeDest.height, _borderDest.top + _borderDest.bottom + _paddingDest.top + _paddingDest.bottom);

    ui_calculate_inner_width(_nodeDest);
    ui_calculate_inner_height(_nodeDest);
}