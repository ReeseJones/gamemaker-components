///@description Calculates a nodes inner width based on its total width and border and padding.
///@param {Struct.ElementSizeProperties} _elementSize
function ui_calculate_inner_width(_elementSize) {
    var _paddingDest = _elementSize.padding;
    var _borderDest = _elementSize.border;
    _elementSize.innerWidth = max(_elementSize.width - _paddingDest.left - _paddingDest.right - _borderDest.left - _borderDest.right, 0);
}

///@description Calculates a nodes inner height based on its total height and border and padding.
///@param {Struct.ElementSizeProperties} _elementSize
function ui_calculate_inner_height(_elementSize) {
    var _paddingDest = _elementSize.padding;
    var _borderDest = _elementSize.border;
    _elementSize.innerHeight = max(_elementSize.height - _paddingDest.top - _paddingDest.bottom - _borderDest.top - _borderDest.bottom, 0);
}