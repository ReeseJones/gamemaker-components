/// @desc Component is the base class for all components.
/// @param {struct.Entity} _entity A reference to which thing this component is bound to.
/// @self Struct.Component
function Component(_entity) constructor {
    static staticIntialization = function(){
        var _staticStruct = static_get(self);
        _staticStruct.name = string_lowercase_first(instanceof(self));
    }
    static __tmp = staticIntialization();

    // Feather disable GM2017
    entityRef = _entity;
    //Run Update on this component
    enabled = true;
    //Run Draw on this component
    visible = true;
    componentIsDestroyed = false;
    // Feather restore GM2017

    static getEntityId = function() {
        return entityRef.entityId;
    }
}

/// @desc ComponentSystem is the base class for all systems which manage a component type. Worlds have systems which add behavior.
/// @param {Struct.World} _world The world which this System operates in.
function ComponentSystem(_world = undefined) constructor {
    static componentConstructor = Component;
    static componentName = "component";
    static staticIntialization = function() {
        var _staticStruct = static_get(self);
        _staticStruct.name = string_lowercase_first(instanceof(self));
        var _sysLen = string_length("system");
        var _sysNameLen = string_length(_staticStruct.name);
        var _compName = string_delete(_staticStruct.name, 1 +_sysNameLen - _sysLen, _sysLen);
        _staticStruct.componentName = _compName;
    }
    static __tmp = staticIntialization();

    //Run update of this entire system
    enabled = true;
    //Run draw of this entire system
    visible = true;
    //What world this system belongs too
    world = _world;

    componentList = [];
    componentsDirty = false;
    
    // Feather restore GM2017

    ///@param {Struct.Entity} _entity
    static addComponent = function(_entity) {
        if(is_undefined(_entity)) {
            throw "Error: Entity must be defined";
        }
        //Create the component
        var _newComponent = new componentConstructor(_entity);
        //Add it into the component map of the entity
        _entity.component[$ componentName] = _newComponent;
        
        //Add it into the systems tracked component list
        array_push(componentList, _newComponent);
        
        //TODO run create code when component is dynamically added?
        onCreate(_newComponent);
        return _newComponent;
    }
    
    static removeComponent = function (_entity) {
        var _componentToRemove = _entity.component[$ componentName];
        if(!_componentToRemove) {
            show_debug_message(string_join("", "Tried from remove component '", componentName,"' from instance with id: ", _entity.entityId, " which did not have this component."));
            return;
        }

        //Run code when component is removed
        destroy(_componentToRemove);

        _componentToRemove.enabled = false;
        _componentToRemove.visible = false;
        _componentToRemove.componentIsDestroyed = true;

        componentsDirty = true;
    }

    //@description Called after all systems are registered to the world.
    static systemStart = function() {

    }

    ///@description Called when the world is destroyed.
    static systemCleanup = function() {

    }

    ///@description Called once per each step of updating the world.
    /// Note this happens only when the world state progresses.
    /// This happens at most only the specified ticksPerSecond
    /// If the ticksPerSecond exceeds the FPS the game is running at
    /// then the updates will effectivley only run at the fps
    /// TODO: dt should be fixed for step, double check that it is.
    ///@param {Real} _dt Delta time in second since last step
    static systemStep = function(_dt) {

    }

    /// @desc onCreate is called after a component has been initialized.
    /// Runs after all values have been deserialized
    /// Or after a component has been dynamically added.
    /// @param {Struct.Component} _component
    static onCreate = function(_component) {
        
    }

    //The step functions happen once per world simulation update.
    //The dt these are passed is a fixed time based on the intended
    //number of frames per second the world simulates at.
    static beginStep = function(_component, _dt) {
        //Runs in the world step phase. Before step and endStep
    }
    
    static runBeginStep = function(_dt) {
        if(!enabled) { return; }

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.enabled) {
                beginStep(_component, _dt);
            }
        }
    }

    //Runs in the world step phase. After beginStep and before endStep
    static step = function(_component, _dt) {

    }

    static runStep = function(_dt) {
        if(!enabled) { return; }

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.enabled) {
                step(_component, _dt);
            }
        }
    }
    
    static endStep = function(_component, _dt) {
        //Runs in the world step phase. After beginStep and Step
    }
    
    static runEndStep = function(_dt) {
        if(!enabled) { return; }

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.enabled) {
                endStep(_component, _dt);
            }
        }
    }

    //All draw Methods happen at the the maximum FPS the game can run.
    //Drawing happens seperate from the world updates.
    //the delta time passed to the draw functions is a percentage of
    //the elapsed current world step. A number from 0 - 1

    static drawBegin = function(_component, _dt) {
        
    }
    
    static runDrawBegin = function(_tickProgress) {
        if(!visible) return;
        
        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                drawBegin(_component, _tickProgress);
            }
        }
    }

    static draw = function(_component, _dt) {
    
    }
    
    static runDraw = function(_tickProgress) {
        if(!visible) return;
        
        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                draw(_component, _tickProgress);
            }
        }
    }
    
    static drawEnd = function(_component, _dt) {
    
    }
    
    static runDrawEnd = function(_tickProgress) {
        if(!visible) return;

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                drawEnd(_component, _tickProgress);
            }
        }
    }
    
    static drawGuiBegin = function(_component, _dt) {
    
    }
    
    static runDrawGuiBegin = function(_tickProgress) {
        if(!visible) return;

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                drawGuiBegin(_component, _tickProgress);
            }
        }
    }
    
    static drawGui = function(_component, _dt) {
    
    }
    
    static runDrawGui = function(_tickProgress) {
        if(!visible) return;

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                drawGui(_component, _tickProgress);
            }
        }
    }
    
    static drawGuiEnd = function(_component, _dt) {
    
    }
    
    static runDrawGuiEnd = function(_tickProgress) {
        if(!visible) return;

        var _componentCount = array_length(componentList);
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentList[i];
            if(_component.visible) {
                drawGuiEnd(_component, _tickProgress);
            }
        }
    }

    static destroy = function(_component) {
        // When removeComponent is called the destroy code runs immediately.
        // When an entity is destroyed and its components are removed this code also runs.
        
        //The component/entity is immediately marked as destroyed, but will not be cleaned up until
        //The end of the step phase immediately following the cleanup event.
        
        // NOTE: The simulation continues to run after this, so it may be wise to leave
        // some resources/assets/references alive until cleanup.
    }

    static cleanup = function(_component) {
        // Similar to destroy except this code runs after all the step events when the entities
        // and components are removed from the world and systems. Should be used to clean up
        // resources that the component allocated that are not automatically cleaned up.
    }
    
    //TODO: Figure out how world/system/entity/component serialization will work.
    
    static serializeBinary = function(_component, _buffer) {
        
    }
    
    static serializeJson = function(_component, _buffer) {
        
    }
    
    static deserializeBinary = function(_component, _buffer) {
        
    }
    
    static deserializeJson = function(_component, _buffer) {
        
    }
    
    static cleanComponentList = function() {
        if(!componentsDirty) return;
        
        componentsDirty = false;
        var _listLength = array_length(componentList);
        var i = _listLength - 1;
        var _swapIndex = i;
        while(i > -1) {
            var _comp = componentList[i];
            if(_comp.componentIsDestroyed) {
                //destroy code
                var _entity = _comp.entityRef;
                //run cleanup method
                cleanup(_comp);
                delete _entity.component[$ componentName];
                variable_struct_remove(_entity.component, componentName);
                _comp.entityRef = undefined;

                //remove from component list
                componentList[i] = componentList[_swapIndex];
                _swapIndex -= 1;
                _listLength -=1;
            }
            i -= 1;
        }
        array_resize(componentList, _listLength);
    }
    
    static toString = function() {
        return string_join("", name, "\nenabled: ", enabled, "\nvisible: ", visible, "\nworldId: ", world.id, "\nComponent Count: ", array_length(componentList));
    }
}