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