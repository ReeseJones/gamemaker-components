///@param {Struct.Box} _destBox
///@param {Struct.Box} _srcBox
///@param {Struct.ElementSizeProperties} _parentSize
function ui_calculate_box_dimensions(_destBox, _srcBox, _parentSize) {
    _destBox.bottom = ui_calculate_edge_dimension(_srcBox.bottom, _parentSize.innerHeight);
    _destBox.top = ui_calculate_edge_dimension(_srcBox.top, _parentSize.innerHeight);
    _destBox.left = ui_calculate_edge_dimension(_srcBox.left, _parentSize.innerWidth);
    _destBox.right = ui_calculate_edge_dimension(_srcBox.right, _parentSize.innerWidth);
}