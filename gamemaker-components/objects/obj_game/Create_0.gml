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

function destroyWorld(_worldId) {
    var _worldRef = getWorldRef(_worldId);

    if(is_undefined(_worldRef)) {
        throw("Tried to delete a world which does not exist.");
    }

    //Mark that this world is being destroyed.
    _worldRef.components.entity.entityIsDestroyed = true;
}

function createWorld(_worldSystems = []) {
    var _newWorldId = getNewWorldId()
    var _newWorld = new World(_newWorldId, _worldSystems);
    array_push(worlds, _newWorld);
    worldsMap[? _newWorldId] = _newWorld;

    return _newWorld;
}

function getWorldRef(_worldId) {
    return worldsMap[? _worldId];
}

function worldExists(_worldId) {
    return ds_map_exists(worldsMap, _worldId);
}

function getNewWorldId() {
    if( array_length(worldIdPool) < 1 ) {
        throw "Oops ran out of world ids";
    }
    return array_pop(worldIdPool);
}

function updateWorlds() {
    var _worldCount = array_length(worlds);
    for(var i = 0; i < _worldCount; i += 1) {
        var _world  = worlds[i];
        _world.step();
    }
    cleanupDestroyedWorlds();
}

function drawWorlds() {
    var _worldCount = array_length(worlds);
    for(var i = 0; i < _worldCount; i += 1) {
        var _world  = worlds[i];
        _world.draw();
    }
}

function drawWorldGuis() {
    var _worldCount = array_length(worlds);
    for(var i = 0; i < _worldCount; i += 1) {
        var _world  = worlds[i];
        _world.drawGui();
    }
}

function cleanupDestroyedWorlds() {
    var _listLength = array_length(worlds);
    var i = _listLength - 1;
    var _swapIndex = i;
    var _destroyedWorlds = false;
    while(i > -1) {
        var _world = worlds[i];
        if(_world.components.entity.entityIsDestroyed) {
            _world.cleanup();
            worlds[i] = worlds[_swapIndex];
            _swapIndex -= 1;
            _listLength -=1;
            _destroyedWorlds = true;
        }
        i -= 1;
    }
    if(_destroyedWorlds) {
        array_resize(worlds, _listLength);
    }
}
