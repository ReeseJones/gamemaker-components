// Feather disable GM2017
#macro ENTITY_INITIAL_ID 100

function add_detached_component(_ref, _component) {
    //Ensure entity exists
    var _entityRef = _ref
    if(!_entityRef) {
        show_debug_message(string_join("", "Tried to add component '", _component, "' to non existant instance with id: ", _ref));
        return;
    }

    var _isStruct = is_struct(_entityRef);
    var _addComponents = false;
    if(_isStruct) {
        if(!variable_struct_exists(_entityRef, "components")) {
            _addComponents = true;
        }
    } else {
        if(!variable_instance_exists(_entityRef, "components")) {
            _addComponents = true;    
        }
    }
    
    if(_addComponents) {
        _entityRef.components = {};    
    }

    var _componentName = script_get_name(_component);
    if(!is_undefined(_entityRef.components[$ _componentName])) {
        throw string_join("", "Component with name: ", _componentName, " has already been added");
    }

    //onCreate the component
    var _newComponent = new _component(_entityRef);
    
    //Add it into the component map of the entity
    _entityRef.components[$ _newComponent.name] = _newComponent;
    
    //Add it into the list of components this entity has
    array_push(_entityRef.components.entity.components, _newComponent);
        

    return _newComponent;
}

function Entity(_ref) : Component(_ref) constructor {
    entityId = undefined;
    components = [];
    entityIsDestroyed = false;
}

function EntitySystem(_world) : ComponentSystem(_world) constructor {
    //Map of all instances belonging to this world
    instances = ds_map_create();
    nextInstanceId = ENTITY_INITIAL_ID;
    componentRemoveQueue = [];
    instanceRemoveQueue = [];

    static registerEntity = function register_entity(_ref, _id = undefined) {
        if(is_undefined(_id)) {
            _id = getNewEntityId();
        } else if ( ds_map_exists(instances, _id) ) {
            throw string_join("", "Instance with id '", _id, "' already exists.");
        }

        _ref.world = world;
        instances[? _id] = _ref;

        var _addComponents = true;
        if ( is_struct(_ref) ) {
            _addComponents = !variable_struct_exists(_ref, "components");
        } else {
            _addComponents = !variable_instance_exists(_ref, "components");
        }
        
        if(_addComponents) {
            _ref.components = {};
        }
        
        if( !variable_struct_exists( _ref.components , "entity")) {
            addComponent(_id, Entity);
            _ref.components.entity.entityId = _id;
        }
        
        //TODO INSTANCE CREATE CODE ??

        return _id;
    }

    static entityDestroy = function entity_destroy(_entityId) {
        if (_entityId < ENTITY_INITIAL_ID) {
            //Less than ENTITY_INITIAL_ID are reserverd for WORLD ids.
            throw(string_join("", "Entity id invalid for deletion: ", _entityId, ". Worlds and  game id may not be destroyed."));    
        }
        var _entityRef = getRef(_entityId);
        if(!_entityRef) {
            show_debug_message(string_join("", "Tried to delete id ", _entityId, " but no entity was found."));
            return;
        }
        
        var _entityComp = _entityRef.components.entity;
        _entityComp.entityIsDestroyed = true;
        
        //TODO: entity component array IS used for destruction! May need to reconsider this later.
        var _comps = _entityComp.components;
        var _componentCount = array_length(_comps);
        for(var i = 0; i < _componentCount; i += 1) {
            removeComponent(_entityId, _comps[i].name);
        }
                
        array_push(instanceRemoveQueue, _entityId);
    }
    
    static getRef = function get_ref(_entityId) {
        return instances[? _entityId];
    }
    
    static getNewEntityId =  function get_new_entity_id() {
        return nextInstanceId++;
    }
    
    static entityIsAlive = function entity_is_alive(_entityId) {
        var _entityRef = instances[? _entityId];
        return _entityRef && !_entityRef.components.entity.entityIsDestroyed;
    }
    
    static entityeExists = function entity_exists(_entityId) {
        return ds_map_exists(instances, _entityId);
    }

    //TODO Use Component Name?
    /// @desc addComponent adds the component to the entity with the specified id.
    /// @param {Real} _entityId The id of the entity to add a component to.
    /// @param {function} _component The component constructor to use.
    static addComponent = function add_component(_entityId, _component) {
        
        //Ensure entity exists
        var _entityRef = getRef(_entityId);
        if(!_entityRef) {
            show_debug_message(string_join("", "Tried to add component '", _component, "' to non existant instance with id: ", _entityId));
            return;    
        }
        
        var _componentName = script_get_name(_component);
        if(!is_undefined(_entityRef.components[$ _componentName])) {
            throw string_join("", "Component with name: ", _componentName, " has already been added");    
        }
        
        //Create the component
        var _newComponent = new _component(_entityRef);
        
        //Add it into the component map of the entity
        _entityRef.components[$ _newComponent.name] = _newComponent;
        
        //Add it into the list of components this entity has
        array_push(_entityRef.components.entity.components, _newComponent);
        
        var _system = world[$ _newComponent.name];
        
        //Add it into the systems tracked component list
        array_push(_system.componentList, _newComponent);
        
        //TODO run create code when component is dynamically added?
        if(is_method(_system.onCreate)) {
            _system.onCreate(_newComponent);
        }
        
        return _newComponent;
    }
    
    static removeComponent = function remove_component(_entityId, _componentName)  {
        var _entityRef = getRef(_entityId);
        if(!_entityRef) {
            show_debug_message(string_join("", "Tried from remove component '", _componentName,"' from non existant instance with id: ", _entityId));
            return;    
        }
        var _componentToRemove = _entityRef.components[$ _componentName];
        if(!_componentToRemove) {
            show_debug_message(string_join("", "Tried from remove component '", _componentName,"' from instance with id: ", _entityId, " which did not have this component."));
            return;    
        }
        
        
        var _system = world[$ _componentName];
        if(is_method(_system.destroy)) {
            _system.destroy(_componentToRemove);
        }
        
        _componentToRemove.enabled = false;
        _componentToRemove.visible = false;
        _componentToRemove.componentIsDestroyed = true;
        
        array_push(componentRemoveQueue, _componentToRemove);
    }

    registerSystemEvent(ES_SYSTEM_CLEANUP);
    static systemCleanup = function system_cleanup() {

        var _entityCount = array_length(componentList);
        for(var i = 0; i < _entityCount; i += 1) {
            entityDestroy(componentList[i].entityId);
        }
        
        runCleanupSweep();
        
        ds_map_destroy(instances);
        instances = undefined;
    }

    registerSystemEvent(ES_SYSTEM_STEP);
    static systemStep = function system_step() {
        runCleanupSweep();
    }
    
    static runCleanupSweep = function run_cleanup_sweep() {
        //Delete queued for deletion components
        var _componentCount = array_length(componentRemoveQueue);
        var _modifiedSystems = {};
        var _systemsThatNeedCleaned = [];
        
        for(var i = 0; i < _componentCount; i += 1) {
            var _component = componentRemoveQueue[i];
            var _entityRef = _component._entityRef;
            var _entityComp = _entityRef.components.entity;
            
            
            var _system = world[$ _component.name];
            if(is_method(_system.cleanup)) {
                _system.cleanup(_component);
            }
            
            if(!variable_struct_exists(_modifiedSystems, _component.name)) {
                _modifiedSystems[$ _component.name] = true;
                array_push(_systemsThatNeedCleaned, _system);
            }
            
            //Remove from entities component array
            array_remove_first(_entityComp.components, _component);
            //Delete from entities component map
            variable_struct_remove(_entityRef.components, _component.name);
            //clear the components entity reference
            _component._entityRef = undefined;
            //Mark _system components as dirty
            _system.componentsDirty = true;
            //Component is disconnected from entity but still lives in the _system update
            //list. The _system will clean out dirty components later at the end of the method.
        }
        array_resize(componentRemoveQueue, 0);

        //Delete queued instances
        var _instanceCount = array_length(instanceRemoveQueue);
        for(var i = 0; i < _instanceCount; i += 1) {
            var _entityId = instanceRemoveQueue[i];
            var _entityRef = getRef(_entityId);
            //Removing the entity from the entity map. (no longer will be found in the world)
            ds_map_delete(instances, _entityId);

            //Clean up entity component structures and clear the world.
            delete _entityRef.components;
            _entityRef.components = undefined;
            _entityRef.world = undefined;
        }
        array_resize(instanceRemoveQueue, 0);
        
        //Cleanup entity component arrays for systems
        var _systemCount = array_length(_systemsThatNeedCleaned);
        for(var i = 0; i < _systemCount; i += 1) {
            var _syst = _systemsThatNeedCleaned[i];
            _syst.cleanComponentList();
        }
    }
}