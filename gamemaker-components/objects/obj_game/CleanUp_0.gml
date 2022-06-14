/// @description Cleanup
var worldCount = array_length(worlds);
for(var i = 0; i < worldCount; i += 1 ) {
	var world = worlds[i];
	DestroyWorld(world.entityId);
}
CleanupDestroyedWorlds();

input_manager_destroy(inputManager);
inputManager = undefined;
input_device_manager_destroy(inputDeviceManager);
inputDeviceManager = undefined;

ds_map_destroy(worldsMap);
worldsMap = undefined;

