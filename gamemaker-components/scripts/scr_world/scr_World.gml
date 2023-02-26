/// @desc World is the container for all systems which create behavior.
/// @param {Struct.WorldTimeManager} _worldTimeManager Time manager which controls passage of
/// @param {Array<Struct.ComponentSystem>} _systems Time manager which controls passage of
/// time in the world and determines when a new frame starts.
/// @param {Struct.LoggingService} _logger
function World(_worldTimeManager, _systems, _logger) constructor {
    // Feather disable GM2017
    id = undefined;
    timeManager = _worldTimeManager;
    systems = _systems;
    logger = _logger;
    system = {};
    systemCount = array_length(systems);
    isDestroyed = false;
    
    instances = ds_map_create();
    instanceRemoveQueue = [];
    // Feather restore GM2017

    //Initialize systems to world
    array_foreach(systems, function(_system) {
        _system.world = self;
        system[$ _system.componentName] = _system;
    });
    //run each systems start.
    array_foreach(systems, function(_system) {
        _system.systemStart();
    });

    ///@param {Real} _entityId
    ///@param {String} _componentName
    static addComponent = function(_entityId, _componentName) {
        var _entityRef = getRef(_entityId);
        if(is_undefined(_entityRef)) {
            logger.logWarning(LOG_LEVEL.IMPORTANT, "Tried to add component '", _componentName, "' to non existant instance with id: ", _entityId); 
            return;
        }

        if(!is_undefined(_entityRef.component[$ _componentName])) {
            logger.logError(LOG_LEVEL.URGENT, "Component with name: ", _componentName, " has already been added");
            throw string_join("", "Component with name: ", _componentName, " has already been added");
        }
        
        var _system = system[$ _componentName];
        return _system.addComponent(_entityRef);
    }

    static destroyComponent = function(_entityId, _componentName) {
        var _entityRef = getRef(_entityId);
        if(is_undefined(_entityRef)) {
            show_debug_message(string_join("", "Tried to remove component '", _componentName, "' to non existant instance with id: ", _entityId));
            return;
        }
        
        var _system = system[$ _componentName];
        return _system.removeComponent(_entityRef);
    }

    static createEntity = function(_entityId) {
        var _newEntity = new Entity(_entityId, self);
        registerEntity(_newEntity, _entityId);
        return _newEntity;
    }

    static destroyEntity = function(_entityId) {
        var _entity = getRef(_entityId);
        if(is_undefined(_entity)) {
            show_debug_message(string_join("", "Tried to delete id ", _entityId, " but no entity was found."));
            return;
        }

        var _comps = variable_struct_get_names(_entity.component);
        var _compCount = array_length(_comps);
        for(var i = 0; i < _compCount; i += 1) {
            var _sys = system[$ _comps[i]];
            _sys.removeComponent(_entity);
        }

        _entity.entityIsDestroyed = true;
        array_push(instanceRemoveQueue, _entityId);
    }

    ///@param {Real} _entityId
    ///@returns {Struct.Entity}
    static getRef = function get_ref(_entityId) {
        return instances[? _entityId];
    }
    
    static entityIsAlive = function(_entityId) {
        var _entityRef = instances[? _entityId];
        return _entityRef && !_entityRef.entityIsDestroyed;
    }
    
    static entityExists = function(_entityId) {
        return ds_map_exists(instances, _entityId);
    }

    static registerEntity = function(_entity, _id) {
        if(is_undefined(_id)) {
            throw "Must have defined entity id";
        } else if ( ds_map_exists(instances, _id) ) {
            throw string_join("", "Entity with id '", _id, "' already exists.");
        }

        instances[? _id] = _entity;
        return _id;
    }
    
    static removeDestroyedEntities = function() {
        var _instanceCount = array_length(instanceRemoveQueue);
        for(var i = 0; i < _instanceCount; i += 1) {
            var _entityId = instanceRemoveQueue[i];
            var _entityRef = getRef(_entityId);
            if(is_undefined(_entityRef)) {
                throw "Entity to be removed is already deleted in removed destroyed entities";
            }
            
            ds_map_delete(instances, _entityId);
            delete _entityRef.component;
            _entityRef.component = undefined;
            _entityRef.world = undefined;
        }
        array_resize(instanceRemoveQueue, 0);
    }

    static step = function() {
        var _progressedTimeSequence = timeManager.stepClock();
        if(!_progressedTimeSequence) return;

        for(var i = 0; i < systemCount; i += 1) {
            var _system = systems[i];
            if(_system.enabled) {
                _system.systemStep(timeManager.secondsPerTick);
            }
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runBeginStep(timeManager.secondsPerTick);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runStep(timeManager.secondsPerTick);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runEndStep(timeManager.secondsPerTick);
        }

        for(var i = 0; i < systemCount; i += 1) {
            var _system = systems[i];
            _system.cleanComponentList();
        }

        removeDestroyedEntities();
    }

    static draw = function() {
        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawBegin(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDraw(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawEnd(timeManager.tickProgress);
        }
    }

    // Feather disable once GM2017
    static drawGui = function() {
        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGuiBegin(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGui(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGuiEnd(timeManager.tickProgress);
        }
    }
    
    static cleanup = function() {
        var _length = array_length(systems);
        for(var i = 0; i < _length; i += 1) {
           var _sys = systems[i];
           _sys.systemCleanup();
           _sys.componentsDirty = true;
           var _compCount = array_length(_sys.componentList);
           for(var j = 0; j < _compCount; j += 1 ) {
               //mark as destroyed so clean component list picks them up.
               _sys.componentList[j].componentIsDestroyed = true;
           }
           _sys.cleanComponentList();
        }

        timeManager = undefined;
        ds_map_destroy(instances);
        instances = undefined;
        systems = undefined;
        systemCount = 0;
        system = undefined;
        //self.id = undefined;
    }

    static debugDraw = function() {
        var _debugText = [
            "FPS: " + string(fps),
            "Real FPS: " + string(fps_real),
            "World Sequence: " + string(timeManager.worldSequence),
            "Target Ticks Per Second: " + string(timeManager.ticksPerSecond),
            "Seconds Per Tick: " + string(timeManager.secondsPerTick),
            "Last tick: " + string(timeManager.secondsSinceLastTick),
            "Tick Progress: " + string(timeManager.tickProgress),
            "Instance Count: " + string(instance_count)
        ];
        var _printText = array_join(_debugText, "\n");
        draw_text(32, 32, _printText);
    }
    

    static toString = function() {
        return string_join("", "WorldID: ", id);
    }
}