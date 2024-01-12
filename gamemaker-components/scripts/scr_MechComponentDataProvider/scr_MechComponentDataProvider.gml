///@param {Array<Struct.MechComponentData>} _components
function MechComponentDataProvider(_components) constructor {
    componentMap = {}
    var _componentCount = array_length(_components);
    for(var i = 0; i < _componentCount; i += 1) {
        var _comp = _components[i];
        componentMap[? _comp.id] = _comp;
    }

/// @param {String}   _componentDataId
/// @return {Struct.MechComponentData}
    static getComponentData = function(_componentDataId) {
        if( !variable_struct_exists(componentMap, _componentDataId) ) {
            throw $"Component with data id {_componentDataId} doesnt exist";
        }

        return componentMap[$ _componentDataId];
    }
}