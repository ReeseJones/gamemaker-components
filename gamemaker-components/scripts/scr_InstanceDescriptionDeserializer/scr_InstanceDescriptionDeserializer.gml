///@param {Struct.AssetGraph} _assetGraph
function deserialize(_assetGraph) {
    var _assetGroup = new AssetGroup();

    // Create all top level instances
    var _assetCount = array_length(_assetGraph.ids);
    var _idList = _assetGraph.ids;
    for(var i = 0; i < _assetCount; i += 1) {
        var _id = _idList[i];
        var _instanceDescription = _assetGraph.instances[$ _id];

        var _newId = undefined;
        var _newInst = undefined;

        if(_instanceDescription.type == "struct") {
            var _structData = struct_get_data(_instanceDescription.assetName);
            // TODO: probably needs to be a factory methods
            _newInst = new _structData.constructorFunc();
            _newInst.id = _id;
            _newId = _id;
        } else {
            var _objIndex = asset_get_index(_instanceDescription.assetName);
            _newInst = instance_create_depth(0, 0, 0, _objIndex);
            _newId = id_to_string(_newInst.id);
        }

        _assetGroup.idMapping[$ _id] = _newId;
        _assetGroup.instances[$ _newId ] = _newInst;
        array_push(_assetGroup.ids, _newId);
    }

    // Now time to apply their properties and connect their references
    for (var i = 0; i < _assetCount; i += 1) {
        var _oldId = _idList[i];
        var _newId = _assetGroup.idMapping[$ _oldId];
        instance_description_apply(_assetGroup, _assetGraph, _oldId, _newId);
    }

    return _assetGroup;
}

function instance_description_apply(_assetGroup, _assetGraph, _oldId, _newId) {
    var _instanceDescription = _assetGraph.instances[$ _oldId];
    var _instance = _assetGroup.instances[$ _newId];
    var _propCount = array_length(_instanceDescription.properties);
    
    var _props = _instanceDescription.properties;
    var _applyPropFunc = is_struct(_instance) ? struct_set : variable_instance_set;
    for(var i = 0; i < _propCount; i += 1) {
        var _propDescription = _props[i];
        var _val = instance_description_resolve_value(_assetGroup, _propDescription);
        _applyPropFunc(_instance, _propDescription.name, _val);
    }
}

///@param {Struct.AssetGroup} _assetGroup
///@param {Struct.ValueDescription} _valueDescription
function instance_description_resolve_value(_assetGroup, _valueDescription) {
    if(!is_struct(_valueDescription)
        || !struct_exists(_valueDescription, "type")
        || !struct_exists(_valueDescription, "value")) {
        show_debug_message($"Error resolving value in instance description: expected value description but got {_valueDescription}. Just resolved with that.");
        return _valueDescription;
    }

    var _val = _valueDescription.value;

    switch(_valueDescription.type) {
        case "number":      return real(_val);
        case "string":      return string(_val);
        case "bool":        return bool(_val);
        case "int32":
        case "int64":       return int64(_val);
        case "ptr":         return ptr(_val);
        case "null":        return pointer_null;
        case "struct":      return _val;
        case "array":       {
                                var _arrayLength = array_length(_val);
                                var _array = array_create(_arrayLength);
                                for(var i = 0; i < _arrayLength; i += 1) {
                                    var _valDesc = _val[i];
                                    _array[i] = instance_description_resolve_value(_assetGroup, _valDesc);
                                }
                                return _array;
                            }
        case "ref":         {
                                if(is_undefined(_val)) { 
                                    return undefined;
                                }
                                var _newId = _assetGroup.idMapping[$ _val ];
                                return _assetGroup.instances[$ _newId];
                            }
        case "undefined":   return undefined;
        case "unkown":
        default:
            throw $"Error value state error! Could not resolve instance description value - type: {_valueDescription.type} value: {_valueDescription.value}";
    }
}