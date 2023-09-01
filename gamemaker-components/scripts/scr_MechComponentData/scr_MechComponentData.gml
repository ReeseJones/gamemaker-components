///@function MechComponentData(_socketPositions)
///@param {String} _name Name of the component
///@param {real} _width The width measured in cells
///@param {real} _height The height measured in cells
///@param {Asset.GMSprite} spriteIndex_ The display sprite for this mech component
///@param {Array<Struct.Vec2>} _sockets The array of sockets this component has.
function MechComponentData(_name, _width, _height, spriteIndex_, _socketPositions = []) constructor {
    name = _name;
    socketPositions = _socketPositions;
    width = _width;
    height = _height;
    spriteIndex = spriteIndex_;
}