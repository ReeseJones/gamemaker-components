///@param {real} _dimension
///@param {real} _parentDimension
function ui_calculate_edge_dimension(_dimension, _parentDimension) {
    if( is_real(_dimension) ) {
        return -1 <= _dimension && _dimension <= 1 && is_real(_parentDimension)
            ? _dimension * _parentDimension
            : _dimension;
    }

    return 0;
}