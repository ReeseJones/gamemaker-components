struct_serialize_as(PlayerInventoryData, nameof(PlayerInventoryData))
///@param {Array<Struct.MechComponent>} _components
function PlayerInventoryData(_components = []) constructor {
    components = _components;
}