event_inherited();

object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
depth = 100;
isDraggable = false;

serviceContainer = global.gameContainer;
/** @type {real} */
inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
saveData = serviceContainer.get("gameSaveData");
gameStaticData = serviceContainer.get("gameStaticData");
editorUi = undefined;

run_all_specs();

// Moves from bootstrap screen to first room
alarm[0] = 10;

window_set_fullscreen(false);

gameStateMode = GAME_STATE_MODE.PLAY;

prevMouseElement = undefined;

