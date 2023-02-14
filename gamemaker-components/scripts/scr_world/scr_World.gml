/// @desc World is the base class for all components.
/// @param {Real} _id the id of this world.
/// @param {Array<Array>} _worldSystems An array of Component Systems to bind to this world.
function World(_id, _worldSystems) constructor {
    // Feather disable GM2017
    entityId = _id;

    worldSequence = 0;
    ticksPerSecond = 10;
    secondsSinceLastTick = 0;
    tickProgress = 0;
    tickDt = 1 / ticksPerSecond;

    entitySystems = [];
    systemEventSubscribers = new SystemEventSubscribers();
    worldSystemDependencies = [];
    // Feather restore GM2017

    static setTickRate = function set_tick_rate(_fps) {
        ticksPerSecond = round(clamp(_fps, 0, 120));
    
        if(ticksPerSecond > 0) {
            tickDt = 1 / ticksPerSecond;
        }
    }

    static cleanup = function cleanup() {
        var _cleanupCount = array_length(systemEventSubscribers.systemCleanup);
        for(var i = 0; i < _cleanupCount; i += 1) {
            var _system = systemEventSubscribers.systemCleanup[i];
            _system.systemCleanup();
        }
        
        delete systemEventSubscribers;
        systemEventSubscribers = undefined;
        entitySystems = undefined;
        worldSystemDependencies = undefined;
        entityId = undefined;
    }

    static step = function step() {
        if(ticksPerSecond < 0) {
            return;
        }

        var _secondsPerTick = (1 / ticksPerSecond);
        var _secondsSinceLastStep = delta_time / MICROSECONDS_PER_SECOND;
        secondsSinceLastTick += _secondsSinceLastStep;
        tickProgress = secondsSinceLastTick / _secondsPerTick;
        
        if( secondsSinceLastTick >= _secondsPerTick ) {
            tickProgress = 0;
            secondsSinceLastTick -= _secondsPerTick;

            //Dispatch World Events

            //System Step
            var _systemCount = array_length(systemEventSubscribers.systemStep);
            for(var i = 0; i < _systemCount; i += 1) {
                var _system = systemEventSubscribers.systemStep[i];
                if(_system.enabled) {
                    _system.systemStep(tickDt);
                }
            }
            
            //Component Begin Step
            _systemCount = array_length(systemEventSubscribers.beginStep);
            for(var i = 0; i < _systemCount; i += 1) {
                var _system = systemEventSubscribers.beginStep[i];
                if(_system.enabled) {
                    var _components = _system.componentList;
                    var _componentCount = array_length(_components);
                    for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                        var _component = _components[_componentIndex];
                        if(_component.enabled) {
                            _system.beginStep(_component ,tickDt);
                        }
                    }
                }
            }
            
            //Component Step
            _systemCount = array_length(systemEventSubscribers.step);
            for(var i = 0; i < _systemCount; i += 1) {
                var _system = systemEventSubscribers.step[i];
                if(_system.enabled) {
                    var _components = _system.componentList;
                    var _componentCount = array_length(_components);
                    for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                        var _component = _components[_componentIndex];
                        if(_component.enabled) {
                            _system.step(_component ,tickDt);
                        }
                    }
                }
            }
            
            //Component endStep
            _systemCount = array_length(systemEventSubscribers.endStep);
            for(var i = 0; i < _systemCount; i += 1) {
                var _system = systemEventSubscribers.endStep[i];
                if(_system.enabled) {
                    var _components = _system.componentList;
                    var _componentCount = array_length(_components);
                    for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                        var _component = _components[_componentIndex];
                        if(_component.enabled) {
                            _system.endStep(_component ,tickDt);
                        }
                    }
                }
            }
            
            worldSequence += 1;
        }
    }

    static draw = function draw() {
        var _systemCount = array_length(systemEventSubscribers.drawBegin);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.drawBegin[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.drawBegin(_component ,tickProgress);
                    }
                }
            }
        }
        
        _systemCount = array_length(systemEventSubscribers.draw);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.draw[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.draw(_component ,tickProgress);
                    }
                }
            }
        }
        
        _systemCount = array_length(systemEventSubscribers.drawEnd);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.drawEnd[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.drawEnd(_component ,tickProgress);
                    }
                }
            }
        }
    }

    // Feather disable once GM2017
    static drawGui = function draw_gui() {
        var _systemCount = array_length(systemEventSubscribers.drawGuiBegin);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.drawGuiBegin[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.drawGuiBegin(_component ,tickProgress);
                    }
                }
            }
        }
        
        _systemCount = array_length(systemEventSubscribers.drawGui);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.drawGui[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.drawGui(_component ,tickProgress);
                    }
                }
            }
        }
        
        _systemCount = array_length(systemEventSubscribers.drawGuiEnd);
        for(var i = 0; i < _systemCount; i += 1) {
            var _system = systemEventSubscribers.drawGuiEnd[i];
            if(_system.visible) {
                var _components = _system.componentList;
                var _componentCount = array_length(_components);
                for(var _componentIndex = 0; _componentIndex < _componentCount; _componentIndex += 1) {
                    var _component = _components[_componentIndex];
                    if(_component.visible) {
                        _system.drawGuiEnd(_component ,tickProgress);
                    }
                }
            }
        }
    }
    
    static debugDraw = function debug_draw() {
        /// @description Debug Draw
        var _debugText = [
        "FPS: " + string(fps),
        "Real FPS: " + string(fps_real),
        "World Sequence: " + string(worldSequence),
        "Target Ticks Per Second: " + string(ticksPerSecond),
        "Seconds Per Tick: " + string(tickDt),
        "Last tick: " + string(secondsSinceLastTick),
        "Tick Progress: " + string(tickProgress),
        "Instance Count: " + string(instance_count)
        ];
        _debugText = array_join(_debugText, "\n");
        draw_text(32, 32, _debugText);
    }

    static initializeWorldSystems = function initialize_world_systems(_worldSystems) {
        //Make copy of input array
        _worldSystems = array_concat_ext(_worldSystems, [], []);
        //Auto added world systems
        //takes Component, Component System, and System Dependencies
        array_push(_worldSystems, 
            [Entity, EntitySystem, []],
            [EntityTree, EntityTreeSystem, []]
        );
    
        var _selfRef = self;
        var _systemDependencyQueue = ds_queue_create();
        
        var _systemsCount = array_length(_worldSystems);
        for(var i = 0; i < _systemsCount; i += 1) {
            var _systemRegistration = _worldSystems[i];
            
            var _componentConstructor = _systemRegistration[0];
            var _systemConstructor = _systemRegistration[1];
            var _componentDependencies = _systemRegistration[2];
            
            //auto add these system dependencies to all systems added to the world.
            array_push(_componentDependencies, Entity, EntityTree);
        
            var _componentName = string_lowercase_first(script_get_name(_componentConstructor));
            if( variable_struct_exists(_selfRef, _componentName) ) {
                var _msg = string_join("", "System with name ", _componentName, " could not be registered because this variable name is already in use on the world.");
                throw(_msg);
            }
            
            //Create and add the system to the world
            var _newSystem = new _systemConstructor(_selfRef);
            _selfRef[$ _componentName] = _newSystem;
            array_push(entitySystems, _newSystem);

            //Queue this system to have its dependencies wired so they can reference each other.
            ds_queue_enqueue(_systemDependencyQueue, {
                system: _newSystem,
                dependencies: array_map(_componentDependencies, function(_dep) {
                    return string_lowercase_first(script_get_name(_dep));
                })
            });
        }

        //Iterate through all the systems to wire up their dependencies.
        while( !ds_queue_empty(_systemDependencyQueue) ) {
            var _sysMetadata = ds_queue_dequeue(_systemDependencyQueue);
            var _numOfDeps = array_length(_sysMetadata.dependencies);
            
            for(var j = 0; j < _numOfDeps; j += 1) {
                var _depName = _sysMetadata.dependencies[j];
                if(variable_struct_exists(_selfRef, _depName)) {
                    _sysMetadata.system[$ _depName] = _selfRef[$ _depName];
                } else {
                    throw(string_join("", "System " , _sysMetadata.system.name ," could not find dep with name ", _depName));
                }
            }
        }

        ds_queue_destroy(_systemDependencyQueue);
        _systemDependencyQueue = undefined;

        worldSystemDependencies = _worldSystems;

        entity.registerEntity(self, entityId);

        //All dependencies are wired and we call the start code on the systems.
        var _systemCount = array_length(systemEventSubscribers.systemStart);
        for(var i = 0; i < _systemCount; i += 1) {
            var _sys = systemEventSubscribers.systemStart[i];
            _sys.systemStart();
        }
    }

    static toString = function to_string() {
        return string_join("WorldID: ", entityId);
    }

    initializeWorldSystems(_worldSystems);
}