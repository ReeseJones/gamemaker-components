function struct_deep_copy(_value) {
    static structDeepCopyHelper = function(_destination, _source) {
        if(!is_struct(_source)) {
            throw ("_source is not a struct");
        }

        var _props = variable_struct_get_names(_source);
        var _propCount = array_length(_props);
        
        for(var i = 0; i < _propCount; i += 1)
        {
            var _propName = _props[i];
            var _propVal = _source[$ _propName];
            // Feather disable once GM2018
            var _copiedValue;
            if(is_struct(_propVal)) {
                _copiedValue = struct_deep_copy(_propVal);
            } else if (is_array(_propVal) ) {
                // Feather disable once GM1043
                _copiedValue = array_deep_copy(_propVal);
            } else {
                _copiedValue = _propVal;
            }
            
            _destination[$_propName] = _copiedValue;
        }
    };

    var _destination = {};
    structDeepCopyHelper(_destination, _value);
    return _destination;
}

function struct_foreach(_struct, _method) {
    var _keys = variable_struct_get_names(_struct);
    
    var _keyCount = array_length(_keys);
    for(var i = 0; i < _keyCount; i += 1) {
        _method(_struct[$ _keys[i]], _struct);
    }
}
