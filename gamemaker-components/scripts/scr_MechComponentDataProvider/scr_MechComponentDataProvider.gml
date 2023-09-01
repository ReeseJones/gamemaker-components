/// @function MechComponentDataProvider
function MechComponentDataProvider() constructor {
    //TODO Destroy Map
    componentDataMap = ds_map_create();
    componentDataMap[? "doodad01"] = new MechComponentData("doodad01", 2, 3, spr_mech_doodad01, [new Vec2(0,0), new Vec2(1,0), new Vec2(0,2), new Vec2(1,2)]);
    componentDataMap[? "doodad02"] = new MechComponentData("doodad02", 4, 1, spr_mech_doodad02, [new Vec2(0,0), new Vec2(3,0)]);
    componentDataMap[? "doodad03"] = new MechComponentData("doodad03", 4, 4, spr_mech_doodad03, [new Vec2(0,0), new Vec2(1,0), new Vec2(2,0), new Vec2(3,0), new Vec2(0,1), new Vec2(3,1), new Vec2(0,2), new Vec2(3,2), new Vec2(0,3), new Vec2(1,3), new Vec2(2,3), new Vec2(3,3)]);
    componentDataMap[? "doodad04"] = new MechComponentData("doodad04", 1, 1, spr_mech_doodad04, [new Vec2(0,0)]);
    componentDataMap[? "doodad05"] = new MechComponentData("doodad05", 2, 2, spr_mech_doodad05, [new Vec2(0,1), new Vec2(1,1)]);
    componentDataMap[? "doodad06"] = new MechComponentData("doodad06", 5, 5, spr_mech_doodad06, [new Vec2(3,0), new Vec2(0,1), new Vec2(0,2), new Vec2(4,4)]);

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