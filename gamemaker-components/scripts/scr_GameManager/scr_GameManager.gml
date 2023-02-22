///@function GameManager(_inputDeviceManager, _inputManager)
///@param {Struct.ServiceFactory} _worldFactory Factory whichs spawns a new world.
function GameManager(_worldFactory) constructor {
    // Feather disable GM2017
    worldFactory = _worldFactory;
    worldsMap = ds_map_create();
    worlds = [];
    isDestroyed = false;
    // Feather restore GM2017

    static destroyWorld = function destroy_world(_worldId) {
        var _worldRef = getWorldRef(_worldId);

        if(is_undefined(_worldRef)) {
            throw("Tried to delete a world which does not exist.");
        }

        //Mark that this world is being destroyed.
        _worldRef.isDestroyed = true;
    }

//@param {string} _id Id for the world
    static createWorld = function create_world(_id) {
        if(worldExists(_id)) {
            throw "World cannot be created: " + string(_id) + " already used.";
        }

        var _newWorld = worldFactory.create();
        _newWorld.id = _id;

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

    static cleanupDestroyedWorlds = function() {
        var _listLength = array_length(worlds);
        var i = _listLength - 1;
        var _swapIndex = i;
        var _destroyedWorlds = false;
        while(i > -1) {
            var _world = worlds[i];
            if(_world.isDestroyed) {
                var _worldId = _world.id;
                _world.cleanup();
                worlds[i] = worlds[_swapIndex];
                ds_map_delete(worldsMap, _worldId);
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
        
        cleanupDestroyedWorlds();
        worlds = [];

        inputManager = undefined;
        inputDeviceManager = undefined;

        if(is_defined(worldsMap)) {
            ds_map_destroy(worldsMap);
            worldsMap = undefined;
        }
    }
}