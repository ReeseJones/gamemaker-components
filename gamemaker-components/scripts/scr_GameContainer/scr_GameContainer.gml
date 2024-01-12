global.gameContainer = new ServiceContainer();
var _gc = global.gameContainer;

_gc.value("gameContainer", global.gameContainer);
_gc.value("gameSaveFileName", file_get_save_directory() + "mech_game_data.json");
_gc.value("gameDataFileName", file_get_save_directory() + "static_data.json");

_gc.factory("gameStaticData", function(_filename) {
    if(file_exists(_filename)) {
        return file_json_read(_filename);
    }

    throw "Couldnt start game, missing static data.";

}, ["gameDataFileName"]);
_gc.factory("gameSaveData", function(_filename) {
    if(file_exists(_filename)) {
        return file_json_read(_filename);
    }

    var _saveData =  new GameData();
    file_json_write(_filename, _saveData);
    return _saveData;
},["gameSaveFileName"]);
_gc.service("mechComponentProvider", MechComponentDataProvider, ["gameStaticData"]);
_gc.service("inputDeviceManager", InputDeviceManager);
_gc.service("inputManager", InputManager, ["inputDeviceManager"]);
_gc.service("debugLogger", LoggingService);
_gc.service("mouseManager", MouseManager, ["debugLogger"]);

_gc.service("realTimeProvider", TimeProvider);