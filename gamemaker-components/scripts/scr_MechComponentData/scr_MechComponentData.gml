struct_serialize_as(MechComponentData, nameof(MechComponentData));
///@function MechComponentData(_socketPositions)
///@param {String} _id Unique component identifier
///@param {real} _width The width measured in cells
///@param {real} _height The height measured in cells
///@param {Asset.GMSprite} spriteIndex_ The display sprite for this mech component
///@param {Array<Struct.Vec2>} _sockets The array of sockets this component has.
function MechComponentData(_id, _width, _height, spriteIndex_, _socketPositions = []) constructor {
    id = _id;
    displayName = "A component";
    socketPositions = _socketPositions;
    width = _width;
    height = _height;
    spriteIndex = spriteIndex_;
    type = "Weapon";
    subtype ="Ballistic";
}