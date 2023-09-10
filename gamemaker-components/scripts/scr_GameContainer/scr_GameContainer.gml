global.gameContainer = new ServiceContainer();
var _gc = global.gameContainer;

_gc.value("gameContainer", global.gameContainer);
_gc.value("gameSaveFileName", file_get_save_directory() + "mech_game_data.json");

_gc.factory("gameSaveData", function(_fileName) {
    if(file_exists(_fileName)) {
        return file_json_read(_fileName);
    } else {
        var _saveData =  game_create_save_data();
        file_json_write(_fileName, _saveData);
        return _saveData;
    }

},["gameSaveFileName"]);
_gc.service("inputDeviceManager", InputDeviceManager);
_gc.service("inputManager", InputManager, ["inputDeviceManager"]);
_gc.service("debugLogger", LoggingService);
_gc.service("mouseManager", MouseManager, ["debugLogger"]);

_gc.service("realTimeProvider", TimeProvider);