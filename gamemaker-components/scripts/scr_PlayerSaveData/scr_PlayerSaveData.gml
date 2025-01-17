struct_save_static( nameof(PlayerSaveData), PlayerSaveData)
function PlayerSaveData() constructor {
    id = uuid_generate();
    saveDisplayName = "Player One";
    
    gameDay = 0;
    credits = 0;
    killCount = 0;
}