///@param {real} _val
///@param {real} _low
///@param {real} _high
function number_in_range(_val, _low, _high) {
    return _low <= _val && _val <= _high;
}

///@param {real} _min
///@param {real} _max
function NumberRange(_min = 0, _max = 1) constructor {
    self.min = _min;
    self.max = _max;
}

///@param {real} _min
///@param {real} _max
///@param {real} _increment
///@param {real} _wiggle
function DynamicNumberRange(_min = 1, _max = 1, _increment = 0, _wiggle = 0) : NumberRange(_min, _max) constructor {
    increment = _increment;
    wiggle = _wiggle;
}