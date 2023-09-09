function struct_serialize_as(_struct, _name) {
    static prototypeMap = {};

    var _static = static_get(_struct);
    if(is_undefined(_static)) {
        throw $"Struct cannot be serialized as {_name}";
    }

    if(variable_struct_exists(prototypeMap, _name)) {
        throw $"Struct cannot be serialized as {_name} because another struct is using that name already.";
    }
    prototypeMap[$ _name] = _static;
    _static.__ssn = _name;
}

function json_serialize(_structOrArray, _prettify = false) {
    var _copyMethod = is_array(_structOrArray) ? array_deep_copy : struct_deep_copy;
    
    _structOrArray = _copyMethod(_structOrArray, undefined, function(_source, _dest) {
        if(is_struct(_source) && variable_struct_exists(_source, "__ssn")) {
            // Save static name for reinstating later.
            var _staticStructName = _source.__ssn;

            // Remove all static properties if they exit
            var _staticSource = static_get(_source);
            if(is_struct(_staticSource)) {
                var _names = variable_struct_get_names(_staticSource);
                var _staticPropCount = array_length(_names);

                for(var i = 0; i < _staticPropCount; i += 1) {
                    var _name = _names[i];

                    if(variable_struct_exists(_dest, _name)) {
                        variable_struct_remove(_dest, _name);
                    }
                }
            }

            //Serialize the static name
            _dest.__ssn = _staticStructName;
        }
    });

    var _text = json_stringify(_structOrArray, _prettify);
    if(is_struct(_structOrArray)) {
        delete _structOrArray;
    }
    return _text;
}

function json_deserialize(_string) {
    var _parsed = json_parse(_string);
    var _copyMethod = is_array(_parsed) ? array_deep_copy : struct_deep_copy;
    
    var _structOrArray = _copyMethod(_parsed, undefined, function(_source, _dest) {
        if(is_struct(_source) && variable_struct_exists(_source, "__ssn")) {
            // Remove the property __ssn property because it will be on the static.
            variable_struct_remove(_dest, "__ssn");
            // Get the static from the static map and hook up the struct.
            var _propMap = static_get(struct_serialize_as).prototypeMap;
            static_set(_dest, _propMap[$ _source.__ssn]);
        }
    });

    if(is_struct(_parsed)) {
        delete _parsed;
    }

    return _structOrArray;
}
