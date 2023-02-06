#macro ENTITY_INITIAL_ID 100

function add_detached_component(_ref, _component) {
    //Ensure entity exists
    var _entityRef = _ref
    if(!_entityRef) {
        show_debug_message(String("Tried to add component '", _component, "' to non existant instance with id: ", _ref));
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

    var componentName = script_get_name(_component);
    if(!is_undefined(_entityRef.components[$ componentName])) {
        throw String("Component with name: ", componentName, " has already been added");
    }

    //OnCreate the component
    var newComponent = new _component(_entityRef);
    
    //Add it into the component map of the entity
    _entityRef.components[$ newComponent.name] = newComponent;
    
    //Add it into the list of components this entity has
    array_push(_entityRef.components.entity.components, newComponent);
        

    return newComponent;
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

    function RegisterEntity(_ref, _id = undefined) {
        if(is_undefined(_id)) {
            _id = GetNewEntityId();
        } else if ( ds_map_exists(instances, _id) ) {
            throw String("Instance with id '", _id, "' already exists.");
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
            AddComponent(_id, Entity);
            _ref.components.entity.entityId = _id;
        }
        
        //TODO INSTANCE CREATE CODE ??

        return _id;
    }
            
    function EntityDestroy(_entityId) {
        if (_entityId < ENTITY_INITIAL_ID) {
            //Less than ENTITY_INITIAL_ID are reserverd for WORLD ids.
            throw(String("Entity id invalid for deletion: ", _entityId, ". Worlds and  game id may not be destroyed."));    
        }
        var _entityRef = GetRef(_entityId);
        if(!_entityRef) {
            show_debug_message(String("Tried to delete id ", _entityId, " but no entity was found."));
            return;
        }
        
        var entityComp = _entityRef.components.entity;
        entityComp.entityIsDestroyed = true;
        
        //TODO: entity component array IS used for destruction! May need to reconsider this later.
        var comps = entityComp.components;
        var componentCount = array_length(comps);
        for(var i = 0; i < componentCount; i += 1) {
            RemoveComponent(_entityId, comps[i].name);
        }
                
        array_push(instanceRemoveQueue, _entityId);
    }
    
    function GetRef(_entityId) {
        return     instances[? _entityId];
    }
    
    function GetNewEntityId() {
        return nextInstanceId++;
    }
    
    function EntityIsAlive(_entityId) {
        var _entityRef = instances[? _entityId];
        return _entityRef && !_entityRef.components.entity.entityIsDestroyed;
    }
    
    function EntityExists(_entityId) {
        return ds_map_exists(instances, _entityId);
    }

    //TODO Use Component Name?
    /// @desc AddComponent adds the component to the entity with the specified id.
    /// @param {Real} _entityId The id of the entity to add a component to.
    /// @param {function} _component The component constructor to use.
    function AddComponent(_entityId, _component) {
        
        //Ensure entity exists
        var _entityRef = GetRef(_entityId);
        if(!_entityRef) {
            show_debug_message(String("Tried to add component '", _component, "' to non existant instance with id: ", _entityId));
            return;    
        }
        
        var componentName = script_get_name(_component);
        if(!is_undefined(_entityRef.components[$ componentName])) {
            throw String("Component with name: ", componentName, " has already been added");    
        }
        
        //Create the component
        var newComponent = new _component(_entityRef);
        
        //Add it into the component map of the entity
        _entityRef.components[$ newComponent.name] = newComponent;
        
        //Add it into the list of components this entity has
        array_push(_entityRef.components.entity.components, newComponent);
        
        var system = world[$ newComponent.name];
        
        //Add it into the systems tracked component list
        array_push(system.componentList, newComponent);
        
        //TODO run create code when component is dynamically added?
        if(is_method(system.OnCreate)) {
            system.OnCreate(newComponent);
        }
        
        return newComponent;
    }
    
    function RemoveComponent(_entityId, _componentName)  {
        var _entityRef = GetRef(_entityId);
        if(!_entityRef) {
            show_debug_message(String("Tried from remove component '", _componentName,"' from non existant instance with id: ", _entityId));
            return;    
        }
        var componentToRemove = _entityRef.components[$ _componentName];
        if(!componentToRemove) {
            show_debug_message(String("Tried from remove component '", _componentName,"' from instance with id: ", _entityId, " which did not have this component."));
            return;    
        }
        
        
        var system = world[$ _componentName];
        if(is_method(system.Destroy)) {
            system.Destroy(componentToRemove);
        }
        
        componentToRemove.enabled = false;
        componentToRemove.visible = false;
        componentToRemove.componentIsDestroyed = true;
        
        array_push(componentRemoveQueue, componentToRemove);
    }

    RegisterSystemEvent(ES_SYSTEM_CLEANUP);
    function systemCleanup() {

        var entityCount = array_length(componentList);
        for(var i = 0; i < entityCount; i += 1) {
            EntityDestroy(componentList[i].entityId);
        }
        
        RunCleanupSweep();
        
        ds_map_destroy(instances);
        instances = undefined;
    }

    RegisterSystemEvent(ES_SYSTEM_STEP);
    function systemStep() {
        RunCleanupSweep();
    }
    
    function RunCleanupSweep() {
        //Delete queued for deletion components
        var componentCount = array_length(componentRemoveQueue);
        var modifiedSystems = {};
        var systemsThatNeedCleaned = [];
        
        for(var i = 0; i < componentCount; i += 1) {
            var component = componentRemoveQueue[i];
            var _entityRef = component._entityRef;
            var entityComp = _entityRef.components.entity;
            
            
            var system = world[$ component.name];
            if(is_method(system.Cleanup)) {
                system.Cleanup(component);
            }
            
            if(!variable_struct_exists(modifiedSystems, component.name)) {
                modifiedSystems[$ component.name] = true;
                array_push(systemsThatNeedCleaned, system);
            }
            
            //Remove from entities component array
            array_remove_first(entityComp.components, component);
            //Delete from entities component map
            variable_struct_remove(_entityRef.components, component.name);
            //clear the components entity reference
            component._entityRef = undefined;
            //Mark system components as dirty
            system.componentsDirty = true;
            //Component is disconnected from entity but still lives in the system update
            //list. The system will clean out dirty components later at the end of the method.
        }
        array_resize(componentRemoveQueue, 0);

        //Delete queued instances
        var instanceCount = array_length(instanceRemoveQueue);
        for(var i = 0; i < instanceCount; i += 1) {
            var entityId = instanceRemoveQueue[i];
            var _entityRef = GetRef(entityId);
            //Removing the entity from the entity map. (no longer will be found in the world)
            ds_map_delete(instances, entityId);

            //Clean up entity component structures and clear the world.
            delete _entityRef.components;
            _entityRef.components = undefined;
            _entityRef.world = undefined;
        }
        array_resize(instanceRemoveQueue, 0);
        
        //Cleanup entity component arrays for systems
        var systemCount = array_length(systemsThatNeedCleaned);
        for(var i = 0; i < systemCount; i += 1) {
            var syst = systemsThatNeedCleaned[i];
            syst.CleanComponentList();
        }
    }
}