///@param {Struct} _static
///@param {Function} _constructor
function StructStaticData(_static, _constructor) constructor {
    structStatic = _static;
    constructorFunc = _constructor;
}

///@description Annotates a struct so that its static is saved when written to and from json.
///@param {String} _name
///@param {Function} _struct
function struct_save_static(_name, _struct) {
    static staticStructMap = {};

    var _static = static_get(_struct);
    if(!is_struct(_static)) {
        throw $"Struct static cannot be saved as {_name}. Struct has no static prototype. (appears to be POD)";
    }

    if(struct_exists(staticStructMap, _name)) {
        throw $"Struct with name {_name} already registered";
    }

    //If we saved the serialization data succesfully, save the name of the static to the prototype.
    _static.__ssn = _name;
    var _data = new StructStaticData(_static, _struct);
    staticStructMap[$ _name] = _data;

    return _data;
}

///@return {string} _ssn struct static name
///@return {Struct.StructStaticData}
function struct_get_data(_ssn) {
    var _structStaticMap = static_get(struct_save_static).staticStructMap;
    var _structData = _structStaticMap[$ _ssn];
    return _structData;
}

///@description Registeres a serializer for a struct and also saves its static
function struct_serialize_as(_name, _struct, _serializer, _deserializer) {
    struct_save_static(_name, _struct);
    serialize_as(_name, _serializer, _deserializer); 
}

///@description struct_static_dehydrate Makes a copy of a json obj and prepares it to be written as a plain json obj which can be rehydrated later.
function struct_static_dehydrate(_structOrArray) {
    var _copyMethod = is_array(_structOrArray) ? array_deep_copy : struct_deep_copy;

    var _copy = variable_clone(_structOrArray);
    variable_foreach(_copy, function(_value) {
        if(!is_struct(_value) || !variable_struct_exists(_value, "__ssn")) {
            return;
        }

        var _staticStructName = _value.__ssn;

        var _staticSource = static_get(_value);
        if(!is_struct(_staticSource)) {
            throw $"Struct has __ssn: {_staticStructName} but no static attached";
        }

        var _names = variable_struct_get_names(_staticSource);
        var _staticPropCount = array_length(_names);

        for(var i = 0; i < _staticPropCount; i += 1) {
            var _name = _names[i];

            if(variable_struct_exists(_value, _name)) {
                variable_struct_remove(_value, _name);
            }
        }

        //Serialize the static name. This is kept to restore the static prototype later when deserialized.
        _value.__ssn = _staticStructName;
    });

    return _copy;
}

///@description struct_static_hydrate takes a json object and turns it into a struct/array instance with struct prototypes restored. Modifies passed in object.
function struct_static_hydrate(_structOrArray) {

    variable_foreach(_structOrArray, function(_value) {
        if(!is_struct(_value) || !variable_struct_exists(_value, "__ssn")) {
            return;
         }

        var _ssn = _value.__ssn;
        // Remove the property __ssn property because it will be on the static.
        variable_struct_remove(_value, "__ssn");
        var _structStaticMap = static_get(struct_save_static).staticStructMap;
        var _structData = _structStaticMap[$ _ssn];
        static_set(_value, _structData.structStatic);
    });

    return _structOrArray;
}