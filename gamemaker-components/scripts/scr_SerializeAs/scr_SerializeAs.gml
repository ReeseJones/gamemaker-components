///@description
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
function SerializerData(_serializer = undefined) constructor {
    serializer = _serializer;
}

///@param {String} _name _serializer(_assetGraph, serializedObj)
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
function serialize_as(_name, _serializer) {
    static serializerMap = {};
    
    var _serializerData;
    if(variable_struct_exists(serializerMap, _name)) {
         throw $"Serializer with name %{_name} already registered!";
    } else {
        _serializerData = new SerializerData(_serializer);
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

///@param {String} _name
///@returns {bool}
function serialize_data_exists(_name) {
    var _serializerMap = static_get(serialize_as).serializerMap;
    return variable_struct_exists(_serializerMap, _name);
}

///@param {Struct.AssetGraph} _assetGraph
function serialize(_assetGraph, _structOrInstance) {
    var _name = "";
    var _parentChain = undefined;
    
    if(is_struct(_structOrInstance) && struct_exists(_structOrInstance, "__ssn")) {
        _name = _structOrInstance.__ssn;
        var _structStaticData = struct_get_data(_name);
        _parentChain = _structStaticData.staticChain;
    } else if(instance_exists(_structOrInstance)) {
        _name = object_get_name(_structOrInstance.object_index);
        var _objectStaticData = object_get_static_data(_structOrInstance.object_index);
        _parentChain = _objectStaticData.objectChain;
    } else {
        throw $"Could not identify struct or instance when serializing {_structOrInstance}.";
    }

    var _chainLength = array_length(_parentChain);
    for(var i = 0; i < _chainLength; i += 1) {
        var _currentName = _parentChain[i];
        if(!serialize_data_exists(_currentName)) {
            continue;
        }
        var _serializeData = serialize_data_get(_currentName);
        _serializeData.serializer(_assetGraph, _structOrInstance);
    }
}