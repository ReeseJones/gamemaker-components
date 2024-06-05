struct_save_static(nameof(GameStaticData), GameStaticData);
///@param {Array<Struct.MechComponentData>} _components
function GameStaticData(_components) constructor {
    /*
    components = [
        new MechComponentData("doodad01", 2, 3, spr_mech_doodad01, [new Vec2(0,0), new Vec2(1,0), new Vec2(0,2), new Vec2(1,2)]),
        new MechComponentData("doodad02", 4, 1, spr_mech_doodad02, [new Vec2(0,0), new Vec2(3,0)]),
        new MechComponentData("doodad03", 4, 4, spr_mech_doodad03, [new Vec2(0,0), new Vec2(1,0), new Vec2(2,0), new Vec2(3,0), new Vec2(0,1), new Vec2(3,1), new Vec2(0,2), new Vec2(3,2), new Vec2(0,3), new Vec2(1,3), new Vec2(2,3), new Vec2(3,3)]),
        new MechComponentData("doodad04", 1, 1, spr_mech_doodad04, [new Vec2(0,0)]),
        new MechComponentData("doodad05", 2, 2, spr_mech_doodad05, [new Vec2(0,1), new Vec2(1,1)]),
        new MechComponentData("doodad06", 5, 5, spr_mech_doodad06, [new Vec2(4,0), new Vec2(0,1), new Vec2(0,2), new Vec2(0,3), new Vec2(4,4)]),
    ];
    */
    components = _components;
}