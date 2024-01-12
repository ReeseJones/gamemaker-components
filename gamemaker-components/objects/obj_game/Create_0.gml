event_inherited();

object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
depth = 100;
isDraggable = false;

serviceContainer = global.gameContainer;
inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
saveData = serviceContainer.get("gameSaveData");
gameStaticData = serviceContainer.get("gameStaticData");

run_all_specs();

alarm[0] = 10;

window_set_fullscreen(false);

