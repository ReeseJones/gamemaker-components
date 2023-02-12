// Feather disable GM2017

/// @desc Component is the base class for all components.
/// @param {Struct} _ref A reference to which thing this component is bound to.
function Component(_ref) constructor {
    name = string_lowercase_first(instanceof(self));
    entityRef = _ref;
    //Run Update on this component
    enabled = true;
    //Run Draw on this component
    visible = true;
    componentIsDestroyed = false;
    
    static getEntityId = function() {
        return entityRef.components.entity.entityId;
    }
}


#macro ES_SYSTEM_START "systemStart"
#macro ES_SYSTEM_CLEANUP "systemCleanup"
#macro ES_SYSTEM_STEP "systemStep"

#macro ES_CREATE "create"
#macro ES_DESTROY "destroy"
#macro ES_CLEANUP "cleanup"

#macro ES_BEGIN_STEP "beginStep"
#macro ES_STEP "step"
#macro ES_END_STEP "endStep"

#macro ES_DRAW_BEGIN "drawBegin"
#macro ES_DRAW "draw"
#macro ES_DRAW_END "drawEnd"
#macro ES_DRAW_GUI_BEGIN "drawGuiBegin"
#macro ES_DRAW_GUI "drawGui"
#macro ES_DRAW_GUI_END "drawGuiEnd"

/// @desc ComponentSystem is the base class for all systems which manage a component type. Worlds have systems which add behavior.
/// @param {Struct.World} _world The world which this System operates in.
function ComponentSystem(_world) constructor {

    name = string_lowercase_first(instanceof(self));
    //Run update of this entire system
    enabled = true;
    //Run draw of this entire system
    visible = true;
    //What world this system belongs too
    world = _world
    
    componentList = [];
    componentsDirty = false;
    
    static systemStart = function system_start() {
        //Called after all systems are registered to the world.
    }

    static systemCleanup = function system_cleanup() {
        //Called when the world is destroyed.
    }

    static systemStep = function system_step() {
        //Called once per each step of updating the world.
        //Note this happens only when the world state progresses.
        //This happens at most only the specified ticksPerSecond
        //If the ticksPerSecond exceeds the FPS the game is running at
        //then the updates will effectivley only run at the fps
        //TODO: dt should be fixed for step, double check that it is.
    }

    /// @desc onCreate is called after a component has been initialized.
    /// @param {Struct.Component} _component description
    static onCreate = function on_create(_component) {
        //Runs after all values have been deserialized
        //Or after a component has been dynamically added.
    }

    //The step functions happen once per world simulation update.
    //The dt these are passed is a fixed time based on the intended
    //number of frames per second the world simulates at.
    static beginStep = function begin_step(_component, _dt) {
        //Runs in the world step phase. Before step and endStep
    }
    
    static step = function step(_component, _dt) {
        //Runs in the world step phase. After beginStep and before endStep
    }
    
    static endStep = function end_step(_component, _dt) {
        //Runs in the world step phase. After beginStep and Step
    }

    //All draw Methods happen at the the maximum FPS the game can run.
    //Drawing happens seperate from the world updates.
    //the delta time passed to the draw functions is a percentage of
    //the elapsed current world step. A number from 0 - 1

    static drawBegin = function draw_begin(_component, _dt) {
        
    }

    static draw = function draw(_component, _dt) {
    
    }
    
    static drawEnd = function draw_end(_component, _dt) {
    
    }
    
    static drawGuiBegin = function draw_gui_begin(_component, _dt) {
    
    }
    
    static drawGui = function draw_gui(_component, _dt) {
    
    }
    
    static drawGuiEnd = function draw_gui_end(_component, _dt) {
    
    }

    static destroy = function destroy(_component) {
        // When removeComponent is called the destroy code runs immdiately.
        // When an entity is destroyed and its components are removed this code also runs.
        
        //The component/entity is immidately marked as destroyed, but will not be cleaned up until
        //The end of the step phase immdiately following the cleanup event.
        
        // NOTE: The simulation continues to run after this, so it may be wise to leave
        // some resources/assets/references alive until cleanup.
    }

    static cleanup = function cleanup(_component) {
        // Similar to destroy except this code runs after all the step events when the entities
        // and components are removed from the world and systems. Should be used to clean up
        // resources that the component allocated that are not automatically cleaned up.
    }
    
    //TODO: Figure out how world/system/entity/component serilization will work.
    
    static serializeBinary = function serialize_binary(_component, _buffer) {
        
    }
    
    static serializeJson = function serialize_json(_component, _buffer) {
        
    }
    
    static deserializeBinary = function deserialize_binary(_component, _buffer) {
        
    }
    
    static deserializeJson = function deserialize_json(_component, _buffer) {
        
    }
    
    static cleanComponentList = function clean_component_list() {
        if(componentsDirty) {
            componentsDirty = false;
            var _listLength = array_length(componentList);
            var i = _listLength - 1;
            var _swapIndex = i;
            while(i > -1) {
                if(componentList[i].componentIsDestroyed) {
                    componentList[i] = componentList[_swapIndex];
                    _swapIndex -= 1;
                    _listLength -=1;
                }
                i -= 1;
            }
            array_resize(componentList, _listLength);
        }
    }
    
    static registerSystemEvent = function register_system_event(_entitySystemEvent) {
        array_push(world.systemEventSubscribers[$ _entitySystemEvent], self);
    }
    
    function toString() {
        return string_join("", name, "\nenabled: ", enabled, "\nvisible: ", visible, "\nworldId: ", world.entityId, "\nComponent Count: ", array_length(componentList));
    }
}