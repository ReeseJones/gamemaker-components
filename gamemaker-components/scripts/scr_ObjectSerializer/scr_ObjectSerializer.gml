///@param {Asset.GMObject} _objectIndex
function ObjectStaticData(_objectIndex) constructor {
    objectName = object_get_name(_objectIndex);
    objectIndex = _objectIndex;
    objectChain = [];

    var _current = _objectIndex;
    while (_current > -1)
    {
        array_push(objectChain, object_get_name(_current));
        _current = object_get_parent(_current);
    };

    // Reverse so we start from parent when iterating.
    array_reverse_ext(objectChain);
}


///@description A decorator which records how an instance should be serialized and deserialized.
///@param {Asset.GMObject} _object
///@param {Function} _serializer _serializer(_assetGraph, serializedObj)
function object_serialize_as(_object, _serializer) {
    static objectSerializerNameMap = {}

    if(!object_exists(_object)) {
        throw $"Object with id %{_object} does not exist!";
    }
    var _objectName = object_get_name(_object);

    if(variable_struct_exists(objectSerializerNameMap, _object)) {
        throw $"Object with name %{_objectName} already regiestered!";
    }

    objectSerializerNameMap[$ _object] = new ObjectStaticData(_object);

    serialize_as(_objectName, _serializer);
}

///@param {Asset.GMObject} _objectIndex
///@return {Struct.ObjectStaticData}
function object_get_static_data(_objectIndex) {
    var _objectSerializerMap = static_get(object_serialize_as).objectSerializerNameMap;
    return _objectSerializerMap[$ _objectIndex];
}