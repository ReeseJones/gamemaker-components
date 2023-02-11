/// @description Cleanup
var _worldCount = array_length(worlds);
for(var i = 0; i < _worldCount; i += 1 ) {
	var _world = worlds[i];
	DestroyWorld(_world.entityId);
}
CleanupDestroyedWorlds();

delete inputManager;
inputManager = undefined;
delete inputDeviceManager;
inputDeviceManager = undefined;

ds_map_destroy(worldsMap);
worldsMap = undefined;

