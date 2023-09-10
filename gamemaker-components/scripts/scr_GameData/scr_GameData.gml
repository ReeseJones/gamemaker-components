struct_serialize_as(GameData, nameof(GameData));
function GameData() constructor {
    var _tempSaveData = new PlayerSaveData();
    previousProfile = _tempSaveData.id
    playerData = [_tempSaveData];
}