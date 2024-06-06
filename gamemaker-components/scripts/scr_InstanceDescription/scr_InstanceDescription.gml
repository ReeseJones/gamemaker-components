///@param {String} _type
///@param {Any} _value
function ValueDescription(_type, _value) constructor {
    type = _type;
    value = _value;
}

///@param {string} _name
///@param {String} _type
///@param {Any} _value
function InstancePropertyDescription(_name, _type, _value) : ValueDescription(_type, _value) constructor {
    name = _name;
}

///@param {string} _assetName
///@param {string} _type
///@param {Any} _id
///@param {Array<Struct.InstancePropertyDescription>} _properties
function InstanceDescription(_assetName, _type, _id, _properties = []) constructor {
    id = id_to_string(_id);
    type = _type;
    assetName = _assetName;
    properties = _properties;
}

///TODO: Check that instance properties added are unique to avoid duplicates
function instance_description_add_property_primitive(_instanceOrStruct, _instanceDesc, _propName) {
    var _get = is_struct(_instanceOrStruct) ? struct_get : variable_instance_get;
    var _propVal = _get(_instanceOrStruct, _propName);
    var _typeName = typeof(_propVal);
    var _newPropDescription = new InstancePropertyDescription(_propName, _typeName, _propVal);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

function instance_description_add_property_instance_ref(_instanceOrStruct, _instanceDesc, _propName) {
    var _get = is_struct(_instanceOrStruct) ? struct_get : variable_instance_get;
    var _propVal = _get(_instanceOrStruct, _propName);
    _propVal = real_id(_propVal);
    var _newPropDescription = new InstancePropertyDescription(_propName, "ref", _propVal);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

///@description Adds a property with an empty array to the instance description
function instance_description_add_property_array(_instanceDesc, _propName) {
    var _newPropDescription = new InstancePropertyDescription(_propName, "array", []);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

///@description Adds a property with an array and assumes all values to be instance references.
function instance_description_add_property_array_instance_ref(_instanceOrStruct, _instanceDesc, _propName) {
    var _get = is_struct(_instanceOrStruct) ? struct_get : variable_instance_get;
    var _array = _get(_instanceOrStruct, _propName);
    var _arrayLength = array_length(_array);
    var _newPropDescription = new InstancePropertyDescription(_propName, "array", []);
    
    for(var i = 0; i < _arrayLength; i += 1) {
        // Convert this from handle to number id since we manually handle restore.
        var _arrayVal = id_to_string(_array[i]);
        var _arrayValueDescription = new ValueDescription("ref", _arrayVal);
        array_push(_newPropDescription.value, _arrayValueDescription);
    }

    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}