struct_serialize_as( nameof(PlayerSaveData), PlayerSaveData)
function PlayerSaveData() constructor {
    id = uuid_generate();
    saveDisplayName = "Player One";
    inventory = new PlayerInventoryData();
}