struct_serialize_as(nameof(MechComponentData), MechComponentData);
///@param {String} _id Unique component identifier
///@param {real} _width The width measured in cells
///@param {real} _height The height measured in cells
///@param {Asset.GMSprite} _spritIndex The display sprite for this mech component
///@param {Array<Struct.Vec2>} _socketPositions The array of sockets this component has.
function MechComponentData(_id, _width, _height, _spritIndex, _socketPositions = []) constructor {
    id = _id;
    displayName = "A component";
    socketPositions = _socketPositions;
    width = _width;
    height = _height;
    spriteIndex = _spritIndex;
    type = "Weapon";
    subtype ="Ballistic";
}