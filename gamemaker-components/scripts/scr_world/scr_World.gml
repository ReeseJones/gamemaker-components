function SystemEventSubscribers() constructor {    
    systemStart = [];
    systemStep = [];
    systemCleanup = [];
    beginStep = [];
    step = [];
    endStep = [];
    drawBegin = [];
    draw = [];
    drawEnd = [];
    drawGuiBegin = [];
    drawGui = [];
    drawGuiEnd = [];
}


/// @desc World is the base class for all components.
/// @param {Real} _id the id of this world.
/// @param {Array<Array>} _worldSystems An array of Component Systems to bind to this world.
function World(_id, _worldSystems) constructor {
    entityId = _id;
    
    worldSequence = 0;
    ticksPerSecond = 10;
    secondsSinceLastTick = 0;
    tickProgress = 0;
    tickDt = 1 / ticksPerSecond;
    
    //These systems add behavior to the world.
    ///@member {Array<Struct.ComponentSystem>}
    entitySystems = [];
    systemEventSubscribers = new SystemEventSubscribers();
    worldSystemDependencies = [];
    
    components = {
        entity: new Entity(self)    
    };
    components.entity.entityId = entityId;

    
    function SetTickRate(_fps) {
        ticksPerSecond = round(clamp(_fps, 0, 120));
    
        if(ticksPerSecond > 0) {
            tickDt = 1 / ticksPerSecond;
        }
    }
    
    function Cleanup() {
        var cleanupCount = array_length(systemEventSubscribers.systemCleanup);
        for(var i = 0; i < cleanupCount; i += 1) {
            var system = systemEventSubscribers.systemCleanup[i];
            system.systemCleanup();
        }
        
        delete systemEventSubscribers;
        systemEventSubscribers = undefined;
        entitySystems = undefined;
        worldSystemDependencies = undefined;
        entityId = undefined;
    }
    
    function Step() {
        if(ticksPerSecond < 0) {
            return;    
        }

        var secondsPerTick = (1 / ticksPerSecond);
        var secondsSinceLastStep = delta_time / MICROSECONDS_PER_SECOND;
        secondsSinceLastTick += secondsSinceLastStep;
        tickProgress = secondsSinceLastTick / secondsPerTick;
        
        if( secondsSinceLastTick >= secondsPerTick ) {
            tickProgress = 0;
            secondsSinceLastTick -= secondsPerTick;

            //Dispatch World Events

            //System Step
            var systemCount = array_length(systemEventSubscribers.systemStep);
            for(var i = 0; i < systemCount; i += 1) {
                var system = systemEventSubscribers.systemStep[i];
                if(system.enabled) {
                    system.systemStep(tickDt);
                }
            }
            
            //Component Begin Step
            systemCount = array_length(systemEventSubscribers.beginStep);
            for(var i = 0; i < systemCount; i += 1) {
                var system = systemEventSubscribers.beginStep[i];
                if(system.enabled) {
                    var components = system.componentList;
                    var componentCount = array_length(components);
                    for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                        var component = components[componentIndex];
                        if(component.enabled) {
                            system.BeginStep(component ,tickDt);
                        }
                    }
                }
            }
            
            //Component Step
            systemCount = array_length(systemEventSubscribers.step);
            for(var i = 0; i < systemCount; i += 1) {
                var system = systemEventSubscribers.step[i];
                if(system.enabled) {
                    var components = system.componentList;
                    var componentCount = array_length(components);
                    for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                        var component = components[componentIndex];
                        if(component.enabled) {
                            system.Step(component ,tickDt);
                        }
                    }
                }
            }
            
            //Component EndStep
            systemCount = array_length(systemEventSubscribers.endStep);
            for(var i = 0; i < systemCount; i += 1) {
                var system = systemEventSubscribers.endStep[i];
                if(system.enabled) {
                    var components = system.componentList;
                    var componentCount = array_length(components);
                    for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                        var component = components[componentIndex];
                        if(component.enabled) {
                            system.EndStep(component ,tickDt);
                        }
                    }
                }
            }
            
            worldSequence += 1;
        }
    }
    
    function Draw() {
        var systemCount = array_length(systemEventSubscribers.drawBegin);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.drawBegin[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.DrawBegin(component ,tickProgress);
                    }
                }
            }
        }
        
        systemCount = array_length(systemEventSubscribers.draw);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.draw[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.Draw(component ,tickProgress);
                    }
                }
            }
        }
        
        systemCount = array_length(systemEventSubscribers.drawEnd);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.drawEnd[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.DrawEnd(component ,tickProgress);
                    }
                }
            }
        }
    }
    
    function DrawGui() {
        var systemCount = array_length(systemEventSubscribers.drawGuiBegin);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.drawGuiBegin[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.DrawGuiBegin(component ,tickProgress);
                    }
                }
            }
        }
        
        systemCount = array_length(systemEventSubscribers.drawGui);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.drawGui[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.DrawGui(component ,tickProgress);
                    }
                }
            }
        }
        
        systemCount = array_length(systemEventSubscribers.drawGuiEnd);
        for(var i = 0; i < systemCount; i += 1) {
            var system = systemEventSubscribers.drawGuiEnd[i];
            if(system.visible) {
                var components = system.componentList;
                var componentCount = array_length(components);
                for(var componentIndex = 0; componentIndex < componentCount; componentIndex += 1) {
                    var component = components[componentIndex];
                    if(component.visible) {
                        system.DrawGuiEnd(component ,tickProgress);
                    }
                }
            }
        }
    }
    
    function DebugDraw() {
        /// @description Debug Draw
        var debugText = [
        "FPS: " + string(fps),
        "Real FPS: " + string(fps_real),
        "World Sequence: " + string(worldSequence),
        "Target Ticks Per Second: " + string(ticksPerSecond),
        "Seconds Per Tick: " + string(tickDt),
        "Last tick: " + string(secondsSinceLastTick),
        "Tick Progress: " + string(tickProgress),
        "Instance Count: " + string(instance_count)
        ];
        debugText = array_join(debugText, "\n");
        draw_text(32, 32, debugText);        
    }
    
    function InitializeWorldSystems(_worldSystems) {
        _worldSystems = array_concat_ext(_worldSystems, [], []);
        //Auto added world systems
        array_push(_worldSystems, 
            [Entity, EntitySystem, []],
            [Eventer, EventerSystem, [EntityTree]],
            [EntityTree, EntityTreeSystem, []]
        );
    
        var selfRef = self;
        var systemDependencyQueue = ds_queue_create();
        
        var systemsCount = array_length(_worldSystems);
        for(var i = 0; i < systemsCount; i += 1) {
            var systemRegistration = _worldSystems[i];
            
            var componentConstructor = systemRegistration[0];
            var systemConstructor = systemRegistration[1];
            var componentDependencies = systemRegistration[2];
            
            //auto add these system dependencies to all systems added to the world.
            array_push(componentDependencies, Entity, Eventer, EntityTree);
        
            var componentName = string_lowercase_first(script_get_name(componentConstructor));
            if( variable_struct_exists(selfRef, componentName) ) {
                var msg = String("System with name ", componentName, " could not be registered because this variable name is already in use on the world.");
                throw(msg);
            }
            
            //Create and add the system to the world
            var newSystem = new systemConstructor(selfRef);
            selfRef[$ componentName] = newSystem;
            array_push(entitySystems, newSystem);

            //Queue this system to have its dependencies wired so they can reference each other.
            ds_queue_enqueue(systemDependencyQueue, {
                system: newSystem,
                dependencies: array_map(componentDependencies, function(_dep) {
                    return string_lowercase_first(script_get_name(_dep));
                })
            });
        }

        //Iterate through all the systems to wire up their dependencies.
        while( !ds_queue_empty(systemDependencyQueue) ) {
            var sysMetadata = ds_queue_dequeue(systemDependencyQueue);
            var numOfDeps = array_length(sysMetadata.dependencies);
            
            for(var j = 0; j < numOfDeps; j += 1) {
                var depName = sysMetadata.dependencies[j];
                if(variable_struct_exists(selfRef, depName)) {
                    sysMetadata.system[$ depName] = selfRef[$ depName];
                } else {
                    throw(String("System " , sysMetadata.system.name ," could not find dep with name ", depName));    
                }
            }
        }
    
        ds_queue_destroy(systemDependencyQueue);
        systemDependencyQueue = undefined;
        
        worldSystemDependencies = _worldSystems;
        
        entity.RegisterEntity(self, entityId);
        
        add_detached_component(self, Eventer);
    
        //All dependencies are wired and we call the start code on the systems.
        var systemCount = array_length(systemEventSubscribers.systemStart);
        for(var i = 0; i < systemCount; i += 1) {
            var sys = systemEventSubscribers.systemStart[i];
            sys.systemStart();    
        }
        
        
    }
    
    function toString() {
        return String("WorldID: ", entityId);
    }
    
    InitializeWorldSystems(_worldSystems);
    
}