/// @desc World is the container for all systems which create behavior.
/// @param {Struct.WorldTimeManager} _worldTimeManager Time manager which controls passage of
/// @param {Array<Struct.ComponentSystem>} _systems Time manager which controls passage of
/// time in the world and determines when a new frame starts.
/// @param {Struct.EntityManager} _entityManager
/// @param {Struct.EntityComponentManager} _componentManager
function World(_worldTimeManager, _systems, _entityManager) constructor {
    // Feather disable GM2017
    id = -1;
    timeManager = _worldTimeManager;
    systems = _systems;
    entityManager = _entityManager;
    system = {};
    systemCount = array_length(systems);
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
        //Ensure entity exists
        var _entityRef = entityManager.getRef(_entityId);
        if(is_undefined(_entityRef)) {
            show_debug_message(string_join("", "Tried to add component '", _componentName, "' to non existant instance with id: ", _entityId));
            return;
        }

        if(!is_undefined(_entityRef.component[$ _componentName])) {
            throw string_join("", "Component with name: ", _componentName, " has already been added");
        }
        
        var _system = system[$ _componentName];
        return _system.addComponent(_entityRef);
    }

    static destroyComponent = function(_entityId, _componentName) {
        //Ensure entity exists
        var _entityRef = entityManager.getRef(_entityId);
        if(is_undefined(_entityRef)) {
            show_debug_message(string_join("", "Tried to remove component '", _componentName, "' to non existant instance with id: ", _entityId));
            return;
        }
        
        var _system = system[$ _componentName];
        return _system.removeComponent(_entityRef);
    }

    static createEntity = function(_entityId) {
        var _newEntity new Entity(_entityId, self);
        entityManager.registerEntity(_newEntity, _entityId);
        return _newEntity;
    }

    static destroyEntity = function(_entityId) {
        var _entity = entityManager.getRef(_entityId);
        if(is_defined(_entity)) {
            var _comps = variable_struct_get_names(_entity.component);
            var _compCount = array_length(_comps);
            for(var i = 0; i < _compCount; i += 1) {
                var _sys = system[$ _comps[i]];
                _sys.removeComponent(_entity);
            }

            entityManager.entityDestroy(_entityId);
        }
    }

    static step = function step() {
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

        entityManager.removeDestroyedEntities();
    }

    static draw = function draw() {
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
    static drawGui = function draw_gui() {
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
    
    static cleanup = function cleanup() {
        var _length = array_length(systems);
        for(var i = 0; i < _length; i += 1) {
           var _sys = systems[i];
           _sys.systemCleanup();
           _sys.componentsDirty = true;
           var _compCount = array_length(_sys.componentList);
           for(var j = 0; j < _compCount; j += 1 ) {
               _sys.componentList[j].componentIsDestroyed = true;
           }
           _sys.cleanComponentList();
        }
        

        timeManager = undefined;
        entityManager.cleanup();
        entityManager = undefined;
        systems = undefined;
        systemCount = 0;
        system = undefined;
        id = undefined;
    }

    static debugDraw = function debug_draw() {
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
    

    static toString = function to_string() {
        return string_join("WorldID: ", id);
    }
}