/// @description Cleanup
var _worldCount = array_length(worlds);
for(var i = 0; i < _worldCount; i += 1 ) {
	var _world = worlds[i];
	DestroyWorld(_world.entityId);
}
CleanupDestroyedWorlds();

input_manager_destroy(inputManager);
inputManager = undefined;
input_device_manager_destroy(inputDeviceManager);
inputDeviceManager = undefined;

ds_map_destroy(worldsMap);
worldsMap = undefined;

