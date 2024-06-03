///@description iterate over every value of a json structured object. Array or struct or value.
///@param {Any} _value
///@param {Function} _callback where signature is callback(value, key, objArrayOrStruct)
function variable_foreach(_value, _callback, _depth = 0) {
    if(_depth == 0) {
        _callback(_value, undefined, undefined);
    }
    if(_depth > 128) {
        throw "variable_foreach > 128! Possible error?";
    }

    if( is_array(_value) ) {
        var _length = array_length(_value);
        for(var i = 0; i < _length; i += 1) {
            var _arrayVal = _value[i];
            _callback(_arrayVal, i, _value);
            variable_foreach(_arrayVal, _callback, _depth + 1);
        }
    } else if( is_struct(_value) ) {
        var _structNames = variable_struct_get_names(_value);
        var _length = array_length(_structNames);
        for(var i = 0; i < _length; i += 1) {
            var _key = _structNames[i];
            var _memberVal = _value[$ _key];
            _callback(_memberVal, _key, _value);
            variable_foreach(_memberVal, _callback, _depth + 1);
        }
    }
}