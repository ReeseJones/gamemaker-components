/// @description Game Creation Code

entityId = EntityId.Game;
inputDeviceManager = input_device_manager_create();
inputManager = input_manager_create(inputDeviceManager);
worldsMap = ds_map_create();
worlds = [];
components = {
	entity: new Entity(self)
};
components.entity.entityId = entityId;

// Create pool of ids.
worldIdPool = array_create(ENTITY_INITIAL_ID, 0);
for(var i = 0; i < ENTITY_INITIAL_ID; i += 1) {
	worldIdPool[i] = i;	
}

AddDetachedComponent(self, Eventer);

function DestroyWorld(_worldId) {
	var worldRef = GetWorldRef(_worldId);
	
	if(is_undefined(worldRef)) {
		throw("Tried to delete a world which does not exist.");
		return;
	}
	
	//Mark that this world is being destroyed.
	worldRef.components.entity.entityIsDestroyed = true;
}

function CreateWorld(_worldSystems = []) {
	var newWorldId = GetNewWorldId()
	var newWorld = new World(newWorldId, _worldSystems);
	array_push(worlds, newWorld);
	worldsMap[? newWorldId] = newWorld;
	
	LinkWorlds(newWorld);
	
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
	//TODO: Flush Queued Game Events
	
	//Update World Simulations
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.Step();
	}
	CleanupDestroyedWorlds();
}

function DrawWorlds() {
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.Draw();
	}
}

function DrawWorldGuis() {
	var worldCount = array_length(worlds);
	for(var i = 0; i < worldCount; i += 1) {
		var world  = worlds[i];
		world.DrawGui();
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
			RemoveRefFromWorlds(world.components.entity.entityId);
			world.Cleanup();
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

function LinkWorlds(_world) {
	array_foreach(worlds, function(world) {
		//Worlds shoulds not register on themselves (they already do on creation)
		if(world != worldRef) {
			//register new world on existing worlds.
			world.entity.RegisterEntity(worldRef, worldRef.entityId);
			//add existing world to new world.
			worldRef.entity.RegisterEntity(world, world.entityId);
		}
	}, {
		worldRef: _world,
	});
}

function RemoveRefFromWorlds(_entityId) {
	array_foreach(worlds, function(world) {
		//basically just unlisting the ref for the world.
		//Only intended to remove world/game_obj references.
		//Not intended for use with regular entities.
		if(!world.components.entity.entityIsDestroyed) {
			ds_map_delete(world.entity.instances, entityId);
		}
	}, {
		entityId: _entityId
	});
}
