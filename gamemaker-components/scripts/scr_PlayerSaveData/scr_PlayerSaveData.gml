struct_serialize_as(PlayerSaveData, nameof(PlayerSaveData))
function PlayerSaveData() constructor {
    id = uuid_generate();
    saveDisplayName = "Player One";
    inventory = new PlayerInventoryData();
}