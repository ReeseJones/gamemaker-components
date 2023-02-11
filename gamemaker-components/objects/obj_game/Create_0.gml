/// @description Game Creation Code

inputDeviceManager = new InputDeviceManager();
inputManager = new InputManager(inputDeviceManager);
worldsMap = ds_map_create();
worlds = [];


// Create pool of ids.
worldIdPool = array_create(ENTITY_INITIAL_ID, 0);
for(var i = 0; i < ENTITY_INITIAL_ID; i += 1) {
	worldIdPool[i] = i;	
}

function DestroyWorld(_worldId) {
	var worldRef = GetWorldRef(_worldId);
	
	if(is_undefined(worldRef)) {
		throw("Tried to delete a world which does not exist.");
	}
	
	//Mark that this world is being destroyed.
	worldRef.components.entity.entityIsDestroyed = true;
}

function CreateWorld(_worldSystems = []) {
	var newWorldId = GetNewWorldId()
	var newWorld = new World(newWorldId, _worldSystems);
	array_push(worlds, newWorld);
	worldsMap[? newWorldId] = newWorld;
	
	return newWorld;
}

function GetWorldRef(_worldId) {
	return worldsMap[? _worldId];	
}

function WorldExists(_worldId) {
	return ds_map_exists(worldsMap, _worldId);
}

function GetNewWorldId() {
	if( array_length(worldIdPool) < 1 ) {
		throw "Oops ran out of world ids";	
	}
	return array_pop(worldIdPool);
}

function UpdateWorlds() {
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.step();
	}
	CleanupDestroyedWorlds();

}

function DrawWorlds() {
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.draw();
	}
}

function DrawWorldGuis() {
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.drawGui();
	}	
}

function CleanupDestroyedWorlds() {
	var listLength = array_length(worlds);
	var i = listLength - 1;
	var swapIndex = i;
	var destroyedWorlds = false;
	while(i > -1) {
		var world = worlds[i];
		if(world.components.entity.entityIsDestroyed) {
			world.cleanup();
			worlds[i] = worlds[swapIndex];
			swapIndex -= 1;
			listLength -=1;
			destroyedWorlds = true;
		}
		i -= 1;
	}
	if(destroyedWorlds) {
		array_resize(worlds, listLength);
	}
}
