enum FLEX_DIRECTION {
    ROW,
    COLUMN,
}

enum OVERFLOW_TYPE {
    VISIBLE,
    HIDDEN,
    SCROLL,
}

enum LAYOUT_TYPE {
    NONE,
    FLEX,
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

    var _positionDest = _node.calculatedSize.position;
    var _positionSrc = _node.sizeProperties.position;

    _borderDest.bottom = ui_calculate_dimension(_borderSrc.bottom, _parentSize.innerHeight);
    _borderDest.top = ui_calculate_dimension(_borderSrc.top, _parentSize.innerHeight);
    _borderDest.left = ui_calculate_dimension(_borderSrc.left, _parentSize.innerWidth);
    _borderDest.right = ui_calculate_dimension(_borderSrc.right, _parentSize.innerWidth);

    _paddingDest.bottom = ui_calculate_dimension(_paddingSrc.bottom, _parentSize.innerHeight);
    _paddingDest.top = ui_calculate_dimension(_paddingSrc.top, _parentSize.innerHeight);
    _paddingDest.left = ui_calculate_dimension(_paddingSrc.left, _parentSize.innerWidth);
    _paddingDest.right = ui_calculate_dimension(_paddingSrc.right, _parentSize.innerWidth);

    _positionDest.bottom = ui_calculate_dimension(_positionSrc.bottom, _parentSize.innerHeight);
    _positionDest.top = ui_calculate_dimension(_positionSrc.top, _parentSize.innerHeight);
    _positionDest.left = ui_calculate_dimension(_positionSrc.left, _parentSize.innerWidth);
    _positionDest.right = ui_calculate_dimension(_positionSrc.right, _parentSize.innerWidth);

    // Width and height is calculated from parents internalWidth and height, which if it has padding will be smaller than its nominal width;
    _nodeDest.width = ui_calculate_dimension(_nodeSrc.width, _parentSize.innerWidth, _positionDest.left, _positionDest.right);
    _nodeDest.height = ui_calculate_dimension(_nodeSrc.height, _parentSize.innerHeight, _positionDest.top, _positionDest.bottom);

    // Choose the larger, padding + border size or initial calculated size. generally should result in calcualted size
    // otherwise that means the border and padding are taking up 100% or more of the desired space.
    _nodeDest.width = max(_nodeDest.width, _borderDest.left + _borderDest.right + _paddingDest.left + _paddingDest.right);
    _nodeDest.height = max(_nodeDest.height, _borderDest.top + _borderDest.bottom + _paddingDest.top + _paddingDest.bottom);

    _nodeDest.innerWidth = _nodeDest.width - _paddingDest.left - _paddingDest.right - _borderDest.left - _borderDest.right;
    _nodeDest.innerHeight = _nodeDest.height - _paddingDest.top - _paddingDest.bottom - _borderDest.top - _borderDest.bottom;
}

///@param {Struct.ElementProperties} _uiRoot
function ui_calculate_layout(_uiRoot, _rootWidth, _rootHeight) {
    static tempParentSize = new ElementProperties();

    //Set root size
    tempParentSize.calculatedSize.height = _rootHeight;
    tempParentSize.calculatedSize.width = _rootWidth;
    tempParentSize.calculatedSize.innerHeight = _rootHeight;
    tempParentSize.calculatedSize.innerWidth = _rootWidth;
    _uiRoot.sizeProperties.width = _rootWidth;
    _uiRoot.sizeProperties.height = _rootHeight;
    // We calculate the root elements size before looping.
    ui_calculate_element_size(_uiRoot, tempParentSize);

    ui_calculate_layout_helper(_uiRoot);
}

///@param {Struct.ElementProperties} _node
function ui_calculate_layout_helper(_node) {

    // Calculate children relative sizes
    var _childrenCount = array_length(_node.childNodes);
    for(var _i = 0; _i < _childrenCount; _i += 1) {
        var _childNode = _node.childNodes[_i];
        ui_calculate_element_size(_childNode, _node);
        ui_calculate_layout_helper(_childNode);
    }

    //TODO: Is this even needed? How do layouts get created?
    // Calculate children layout
    for(var _i = 0; _i < _childrenCount; _i += 1) {
        var _childNode = _node.childNodes[_i];
       
    }
}




// Ratio Sizing - 100% or 50% of container
// fixed sizing - 300px;
// content sizing - as big as content // text for example
    // max width
    // max height
// sized by parent:
/*
    panel:
        width = 0.3; // 30% of parent
        height = 1.0; // 100% of parent
        overflow: VISIBLE
        layout: FLEX
        flexDirection: COULMN
        display: box

    Header:
        width = 1.0;
        height = 0.2;
        overflow = VISIBLE
        layout: NONE
        flexType: static
        flex = 0.2 // Reserves 1/5th of flex container
        display: controlled by flex

    ContentContainer:
        width: 1.0
        height: 1.0
        layout: STACK
        overflow: SCROLL
        flexType: grow
        flex: 1.0 // shares rest of flex
        display: controlled by flex

     WeaponDataContainer:
        width: 1.0
        height: 1.0
        overflow: VISIBLE
        layout: FLEX
        flexType: static
        flex: 1
        display: controlled by content
        fitMode: Height //width | Height | Both

      Weapon Header Row:
        width: 1.0
        height: 1.0
        overflow: visible
        layout: Flex
        flexDirection: ROW
        flexType: static
        flex: 1
        display: width controlled by width, height controlled by content
        fitMode: Height

     WeaponIcon: // Sizes to container. Maintain aspect ratio?

     Weapon Name:// size driven by content

     Weapon Stats:


*/