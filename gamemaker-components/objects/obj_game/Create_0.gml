event_inherited();

object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
depth = 100;
isDraggable = false;

serviceContainer = global.gameContainer;
inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
data = serviceContainer.get("gameSaveData");

run_all_specs();