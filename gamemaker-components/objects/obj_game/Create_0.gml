/// @description Creation
entityId = EntityId.Game;

inputDeviceManager = input_device_manager_create();
inputManager = input_manager_create(inputDeviceManager);

worlds = [];
nextWorldId = 0;

function LoadEmptyWorld() {
	var newWorldId = GetNewWorldId()
	var newWorld = new World(newWorldId, global.defaultWorldSystems);
	worlds[newWorldId] = newWorld;
	return newWorld;
}

function GetNewWorldId() {
	if(nextWorldId >= ENTITY_INITIAL_ID) {
		throw "Oops ran out of world ids";	
	}
	return nextWorldId++;
}
