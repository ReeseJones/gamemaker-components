/// @description Creation
entityId = EntityId.Game;

inputDeviceManager = input_device_manager_create();
inputManager = input_manager_create(inputDeviceManager);

worlds = [];
nextWorldId = 0;

//TODO GET RID OF THIS
function UpdateWorldInstanceReferences() {
	var worldCount = array_length(worlds);
	for (var i = 0; i < worldCount; i += 1) {
		var world = worlds[i];
		if (world) {
			for (var j = 0; j < worldCount; j += 1) {
				world.entity.instances[? j] = worlds[j];
			}
		}
	}
}

function LoadEmptyWorld() {
	var newWorld = new World(GetNewWorldId(), global.defaultWorldSystems);
	worlds[newWorld.entityId] = newWorld;
	UpdateWorldInstanceReferences();
	return newWorld;
}

function GetNewWorldId() {
	if(nextWorldId >= ENTITY_INITIAL_ID) {
		throw "Oops ran out of world ids";	
	}
	return nextWorldId++;
}
