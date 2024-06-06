///@description
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
///@param {Function} _deserializer _deserializer(_assetGraph, serializedObj)
function SerializerData(_serializer = undefined, _deserializer = undefined) constructor {
    serializer = _serializer;
    deserializer = _deserializer;
}

///@param {String} _name _serializer(_assetGraph, serializedObj)
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
///@param {Function} _deserializer _deserializer(_assetGraph, serializedObj)
function serialize_as(_name, _serializer, _deserializer) {
    static serializerMap = {};
    
    var _serializerData;
    if(variable_struct_exists(serializerMap, _name)) {
         throw $"Serializer with name %{_name} already registered!";
    } else {
        _serializerData = new SerializerData(_serializer, _deserializer);
    }

    serializerMap[$ _name] = _serializerData;
}

///@param {String} _name
///@returns {Struct.SerializerData}
function serialize_data_get(_name) {
    var _serializerMap = static_get(serialize_as).serializerMap;

    if(variable_struct_exists(_serializerMap, _name)) {
         return _serializerMap[$ _name];
    } else {
        throw $"Serializer data with name {_name} doesnt exist!";
    }
}

///@param {Struct.AssetGraph} _assetGraph
function serialize(_assetGraph, _structOrInstance) {
    var _name = "";
    if(is_struct(_structOrInstance) && struct_exists(_structOrInstance, "__ssn")) {
        _name = _structOrInstance.__ssn;
    } else if(instance_exists(_structOrInstance)) {
        _name = object_get_name(_structOrInstance.object_index);
    } else {
        throw $"Could not identify struct or instance when serializing {_structOrInstance}.";
    }

    var _serializeData = serialize_data_get(_name);

    _serializeData.serializer(_assetGraph, _structOrInstance);
}