///@description A decorator which records how an instance should be serialized and deserialized.
///@param {Asset.GMObject} _object
///@param {Function} _serializer Should take as input the same thing the deserializer outputs
///@param {Function} _deserializer Should take as input the same thing the serializer outputs
function object_serialize_as(_object, _serializer, _deserializer) {
    static objectSerializerNameMap = {}
    
    if(!object_exists(_object)) {
        throw $"Object with id %{_object} does not exist!";
    }
    var _objectName = object_get_name(_object);

    if(variable_struct_exists(objectSerializerNameMap, _object)) {
        throw $"Object with name %{_objectName} already regiestered!";
    }

    objectSerializerNameMap[$ _object] = _objectName;

    serialize_as(_objectName, undefined, _serializer, _deserializer);
}