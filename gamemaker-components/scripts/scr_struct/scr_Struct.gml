///@param {Struct} _source
///@param {Struct} _destination
///@param {Function} _callback
///@return {Struct}
function struct_deep_copy(_source, _destination = {}, _callback = undefined) {
    if(!is_struct(_source)) {
        throw ("_source is not a struct");
    }
    if(!is_struct(_destination)) {
        throw ("_destination is not a struct");
    }

    var _props = variable_struct_get_names(_source);
    var _propCount = array_length(_props);
        
    for(var i = 0; i < _propCount; i += 1)
    {
        var _propName = _props[i];
        var _propVal = _source[$ _propName];

        var _copiedValue = undefined;
        if(is_struct(_propVal)) {
            _copiedValue = struct_deep_copy(_propVal, {}, _callback);
        } else if (is_array(_propVal) ) {
            _copiedValue = array_deep_copy(_propVal, [], _callback);
        } else {
            _copiedValue = _propVal;
        }

        _destination[$ _propName] = _copiedValue;
    }

    if(is_callable(_callback)) {
        _callback(_source, _destination);
    }

    return _destination;
}

///@param {Struct} _struct
///@param {Function} _method
function struct_foreach_custom(_struct, _method) {
    var _keys = variable_struct_get_names(_struct);
    
    var _keyCount = array_length(_keys);
    for(var i = 0; i < _keyCount; i += 1) {
        _method(_struct[$ _keys[i]], _struct);
    }
}

///@param {Struct} _struct
function struct_get_id(_struct) {
    if(struct_exists(_struct, "id")) {
        return id_to_string(_struct.id);
    }
    _struct.id = id_to_string(ptr(_struct));
    return _struct.id;
}