function struct_serialize_as(_name, _struct, _serializer = struct_serialize_default, _deserializer = struct_deserialize_default) {

    var _static = static_get(_struct);
    if(!is_struct(_static)) {
        throw $"Struct cannot be serialized as {_name}. Struct has no static prototype. (appears to be POD)";
    }

    serialize_as(_name, _static, _serializer, _deserializer);

    //If we saved the serialization data succesfully, save the name of the static to the prototype.
    _static.__ssn = _name;
}

///@description struct_serialize_default Readies a struct (or array) that can be written as json to a file. Copies passed in value.
function struct_serialize_default(_structOrArray) {
    var _copyMethod = is_array(_structOrArray) ? array_deep_copy : struct_deep_copy;

    var _copy = _copyMethod(_structOrArray, undefined, function(_source, _dest) {
        //If we are not iterating over a serialized struct, default copy is okay. end early.
        if(!is_struct(_source) || !variable_struct_exists(_source, "__ssn")) {
            return;
        }

        //Otherwise we do some special wiring for structs with static prototypes
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

        //Serialize the static name. This is kept to restore the static prototype later when deserialized.
        _dest.__ssn = _staticStructName;
    });

    return _copy;
}

///@description struct_deserialize_default takes a json object and turns it into a struct/array instance with struct prototypes restored. Modifies passed in object.
function struct_deserialize_default(_structOrArray) {

    variable_foreach(_structOrArray, function hookUpStaticStruct(_value) {
        if(!is_struct(_value) || !variable_struct_exists(_value, "__ssn")) {
            return;
         }

        var _ssn = _value.__ssn;
        // Remove the property __ssn property because it will be on the static.
        variable_struct_remove(_value, "__ssn");
        var _serializerData = serialize_data_get(_ssn);
        static_set(_value, _serializerData.structStatic);
    });

    return _structOrArray;
}
