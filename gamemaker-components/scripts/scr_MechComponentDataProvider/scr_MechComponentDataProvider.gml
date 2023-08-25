/// @function MechComponentDataProvider
function MechComponentDataProvider() constructor {
    //TODO Destroy Map
    componentDataMap = ds_map_create();
    componentDataMap[? "testTwoByThree"] = mech_testing_data_get()[0];

/// @function getComponentData(_componentDataId)
/// @param {String}   _componentDataId
/// @return {Struct.MechComponentData}
    static getComponentData = function(_componentDataId) {
        if( !ds_map_exists(componentDataMap, _componentDataId) ) {
            throw $"Component with data id {_componentDataId} doesnt exist";
        }

        return componentDataMap[? _componentDataId];
    }
}

global.mechComponentDataProvider = new MechComponentDataProvider();