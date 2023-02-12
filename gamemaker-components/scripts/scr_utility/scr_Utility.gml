function is_equal(_val1, _val2) {
    return _val1 == _val2;
}


function value_or_default(_value, _default) {
    if(is_undefined(_value)) {
        return _default;
    }
    return _value;
}

function instance_name(_id) {
    if ( instance_exists(_id) ) {
        return object_get_name(_id.object_index);
    }
    return "undefined";
}


function string_lowercase_first(_str) {
    var _strLength = string_length(_str);
    if(_strLength == 0) { 
        return "";
    }

    var _firstChar = string_char_at(_str, 1);
    var _lowercaseChar = string_lower(_firstChar);
    var _copyLength = _strLength - 1;
    if(_copyLength > 0) {
        return _lowercaseChar + string_copy(_str, 2, _copyLength);
    }
    return _lowercaseChar;
}