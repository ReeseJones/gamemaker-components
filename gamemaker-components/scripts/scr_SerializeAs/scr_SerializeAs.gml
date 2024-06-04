///@description
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
///@param {Function} _deserializer _deserializer(_assetGraph, serializedObj)
///@param {Struct} _structStatic
function SerializerData(_serializer = undefined, _deserializer = undefined, _structStatic = undefined) constructor {
    serializer = _serializer;
    deserializer = _deserializer;
    structStatic = _structStatic;
}

///@param {String} _name _serializer(_assetGraph, serializedObj)
///@param {Struct OR Asset.GameObject} _structStatic
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
///@param {Function} _deserializer _deserializer(_assetGraph, serializedObj)
function serialize_as(_name, _structStatic, _serializer, _deserializer) {
    static serializerMap = {};
    
    var _serializerData;
    if(variable_struct_exists(serializerMap, _name)) {
         throw $"Serializer with name %{_name} already registered!";
    } else {
        _serializerData = new SerializerData(_serializer, _deserializer, _structStatic);
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
        throw $"Serializer data with name %{_name} doesnt exist!";
    }
}