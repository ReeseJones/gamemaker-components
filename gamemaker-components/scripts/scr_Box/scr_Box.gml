struct_save_static(nameof(Box), Box);
///@param {real} _top
///@param {real} _left
///@param {real} _bottom
///@param {real} _right
function Box(_top = undefined, _left = undefined, _bottom = undefined, _right = undefined) constructor {
    top = _top;
    left = _left;
    bottom = _bottom;
    right = _right;
}

global.boxZero = new Box(0, 0, 0, 0);