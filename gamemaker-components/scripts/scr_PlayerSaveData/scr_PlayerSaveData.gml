struct_save_static( nameof(PlayerSaveData), PlayerSaveData)
function PlayerSaveData() constructor {
    id = uuid_generate();
    saveDisplayName = "Player One";
    inventory = new PlayerInventoryData();
}