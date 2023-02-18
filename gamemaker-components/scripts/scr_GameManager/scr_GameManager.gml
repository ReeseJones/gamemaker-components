///@function GameManager(_inputDeviceManager, _inputManager)
///@param {Struct.InputDeviceManager} _inputDeviceManager This is an input device manager
///@param {Struct.InputManager} _inputManager this is an input manager
///@param {Struct.ServiceFactory} _worldFactory Factory whichs spawns a new world.
function GameManager(_inputDeviceManager, _inputManager, _worldFactory) constructor {
    // Feather disable GM2017
    inputDeviceManager =_inputDeviceManager;
    inputManager = _inputManager;
    worldFactory = _worldFactory;

    worldsMap = ds_map_create();
    worlds = [];
    isDestroyed = false;

    worldIdPool = array_create(ENTITY_INITIAL_ID, 0);
    for(var i = 0; i < ENTITY_INITIAL_ID; i += 1) {
        worldIdPool[i] = i;
    }
    // Feather restore GM2017

    static destroyWorld = function destroy_world(_worldId) {
        var _worldRef = getWorldRef(_worldId);

        if(is_undefined(_worldRef)) {
            throw("Tried to delete a world which does not exist.");
        }

        //Mark that this world is being destroyed.
        _worldRef.isDestroyed = true;
    }

    static createWorld = function create_world() {
        var _newWorld = worldFactory.create();
        _newWorld.id = getNewWorldId();

        array_push(worlds, _newWorld);
        worldsMap[? _newWorld.id] = _newWorld;

        return _newWorld;
    }

    static getWorldRef = function get_world_ref(_worldId) {
        return worldsMap[? _worldId];
    }

    static worldExists = function world_exists(_worldId) {
        return ds_map_exists(worldsMap, _worldId);
    }

    static getNewWorldId = function get_new_world_id() {
        if( array_length(worldIdPool) < 1 ) {
            throw "Oops ran out of world ids";
        }
        return array_pop(worldIdPool);
    }

    static updateWorlds = function update_worlds() {
        var _worldCount = array_length(worlds);
        for(var i = 0; i < _worldCount; i += 1) {
            var _world  = worlds[i];
            _world.step();
        }
        cleanupDestroyedWorlds();
    }

    static drawWorlds = function draw_worlds() {
        var _worldCount = array_length(worlds);
        for(var i = 0; i < _worldCount; i += 1) {
            var _world  = worlds[i];
            _world.draw();
        }
    }

    static drawWorldGuis = function draw_world_guis() {
        var _worldCount = array_length(worlds);
        for(var i = 0; i < _worldCount; i += 1) {
            var _world  = worlds[i];
            _world.drawGui();
        }
        //TODO DELETE TEST CODE
        if(array_length(worlds) > 0) {
            var _world = worlds[0];
            _world.debugDraw();
        }
    }

    static cleanupDestroyedWorlds = function cleanup_destroyed_worlds() {
        var _listLength = array_length(worlds);
        var i = _listLength - 1;
        var _swapIndex = i;
        var _destroyedWorlds = false;
        while(i > -1) {
            var _world = worlds[i];
            if(_world.isDestroyed) {
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
    
    static cleanup = function cleanup() {
        array_foreach(worlds, function(_world) {
             destroyWorld(_world.id);
        });
        worlds = [];
        cleanupDestroyedWorlds();

        inputManager = undefined;
        inputDeviceManager = undefined;

        if(is_defined(worldsMap)) {
            ds_map_destroy(worldsMap);
            worldsMap = undefined;
        }
    }
}