///@function MechComponentData(_socketPositions)
///@param {String} _name Name of the component
///@param {real} _width The width measured in cells
///@param {real} _height The height measured in cells
///@param {Array<Struct.Vec2>} _sockets The array of sockets this component has.
function MechComponentData(_name, _width, _height, _socketPositions = []) constructor {
    name = _name;
    socketPositions = _socketPositions;
    width = _width;
    height = _height;
    spriteIndex = choose(spr_mech_doodad01, spr_mech_doodad02, spr_mech_doodad03, spr_mech_doodad04,spr_mech_doodad05, spr_mech_doodad06);
}