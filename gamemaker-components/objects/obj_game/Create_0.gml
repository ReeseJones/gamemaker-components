event_inherited();

object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
isDraggable = false;

serviceContainer = global.gameContainer;
inputDeviceManager = serviceContainer.get("inputDeviceManager");