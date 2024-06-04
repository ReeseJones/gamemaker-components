function InstanceBuiltInProperties() constructor {
    visible = true;
    solid = true;
    persistent = false;
    layer = 0; 
    friction = 0;
    gravity = 0;
    gravity_direction = 270;
    direction = 0;
    speed = 0;
    x = 0;
    y = 0;
    sprite_index = 0;
    image_alpha = 1;
    image_angle = 0;
    image_blend = c_white;
    image_index = 0;
    image_speed = 1;
    image_xscale = 1;
    image_yscale = 1;
    mask_index = 0;
}

enum PROPERTY_DESCRIPTION_TYPE {
    PRIMITIVE = 1,
    STRUCT_REF = 2,
    INSTANCE_REF = 3,
    ARRAY = 4,
    STRUCT = 5,
    COUNT = 6
}

///@param {Real} _type
///@param {Any} _value
function ValueDescription(_type, _value) constructor {
    type = _type;
    value = _value;
}

///@param {string} _name
///@param {Real} _type
///@param {Any} _value
function InstancePropertyDescription(_name, _type, _value) : ValueDescription(_type, _value) constructor {
    name = _name;
}

///@param {string} _assetName
///@param {real} _id
///@param {Array<Struct.InstancePropertyDescription>} _properties
function InstanceDescription(_assetName, _id, _properties = []): AssetDescription(_assetName, _id) constructor {
    properties = _properties;
}

///TODO: Check that instance properties added are unique to avoid duplicates
function instance_description_add_property_primitive(_instance, _instanceDesc, _propName) {
    var _propVal = variable_instance_get(_instance, _propName);
    var _newPropDescription = new InstancePropertyDescription(_propName, PROPERTY_DESCRIPTION_TYPE.PRIMITIVE, _propVal);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

function instance_description_add_property_instance_ref(_instance, _instanceDesc, _propName) {
    var _propVal = variable_instance_get(_instance, _propName);
    var _newPropDescription = new InstancePropertyDescription(_propName, PROPERTY_DESCRIPTION_TYPE.INSTANCE_REF, _propVal);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

///@description Adds a property with an empty array to the instance description
function instance_description_add_property_array(_instanceDesc, _propName) {
    var _newPropDescription = new InstancePropertyDescription(_propName, PROPERTY_DESCRIPTION_TYPE.ARRAY, []);
    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}

///@description Adds a property with an array and assumes all values to be instance references.
function instance_description_add_property_array_instance_ref(_instance, _instanceDesc, _propName) {
    var _array = variable_instance_get(_instance, _propName);
    var _arrayLength = array_length(_array);
    var _newPropDescription = new InstancePropertyDescription(_propName, PROPERTY_DESCRIPTION_TYPE.ARRAY, []);
    
    for(var i = 0; i < _arrayLength; i += 1) {
        var _arrayVal = _array[i];
        var _arrayValueDescription = new ValueDescription(PROPERTY_DESCRIPTION_TYPE.INSTANCE_REF, _arrayVal);
        array_push(_arrayValueDescription.value, _arrayValueDescription);
    }

    array_push(_instanceDesc.properties, _newPropDescription);
    return _newPropDescription;
}