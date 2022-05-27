#macro ENTITY_INITIAL_ID 100
#macro MASK_SIZE_POWER 6
#macro MASK_RESOLUTION 64

function Entity(_ref) : Component(_ref) constructor {
	entityId = undefined;
	components = [];
	entityIsDestroyed = false;
	
	//TODO It may be a bad idea for the entity to store itself in the list of components but we are doin it.
	array_push(components, self);
}

function EntitySystem(_world) : ComponentSystem(_world) constructor {
	//Map of all instances belonging to this world
	instances = ds_map_create();
	nextInstanceId = ENTITY_INITIAL_ID;
	componentRemoveQueue = [];
	instanceRemoveQueue = [];
	
	function SystemStart() {
		//TODO MAKE THIS INSTANCES MAP HAVE ALL WORLDS and OBJ_GAME
		instances[? EntityId.Game] = instance_find(obj_game, 0);
		instances[? world.entityId] = world;
	}
	
	function RegisterEntity(_ref, _id = undefined) {
		if(is_undefined(_id)) {
			_id = GetNewEntityId();
		} else if ( ds_map_exists(instances, _id) ) {
			throw String("Instance with id '", _id, "' already exists.");
		}
		
		_ref.world = world;
		instances[? _id] = _ref;
		
		var entityComponent = new Entity(_ref);
		entityComponent.entityId = _id;
		_ref.components = {entity: entityComponent};
		
		AddComponent(_id, Eventer)
		
		//TODO INSTANCE CREATE CODE
		
		return _id;
	}
			
	function EntityDestroy(_entityId) {
		if (_entityId < ENTITY_INITIAL_ID) {
			//Less than ENTITY_INITIAL_ID are reserverd for WORLD ids.
			throw(String("Entity id invalid for deletion: ", _entityId));	
		}
		var entityRef = GetRef(_entityId);
		if(!entityRef) {
			show_debug_message(String("Tried to delete id ", _entityId, " but no entity was found."));
			return;
		}
		
		var entityComp = entityRef.components.entity;
		entityComp.entityIsDestroyed = true;
		
		var comps = entityComp.components;
		var componentCount = array_length(comps);
		for(var i = 0; i < componentCount; i += 1) {
			RemoveComponent(_entityId, comps[i].name);
		}
				
		array_push(instanceRemoveQueue, _entityId);
	}
	
	function GetRef(_entityId) {
		return 	instances[? _entityId];
	}
	
	function GetNewEntityId() {
		return nextInstanceId++;
	}
	
	function EntityIsAlive(_entityId) {
		var entityRef = instances[? _entityId];
		return entityRef && !entityRef.components.entity.entityIsDestroyed;
	}
	
	function EntityExists(_entityId) {
		return ds_map_exists(instances, _entityId);
	}

	//TODO Use Component Name?
	function AddComponent(_entityId, _component) {
		
		//Ensure entity exists
		var entityRef = GetRef(_entityId);
		if(!entityRef) {
			show_debug_message(String("Tried to add component '", _component, "' to non existant instance with id: ", _entityId));
			return;	
		}
		
		//Create the component
		var newComponent = new _component(entityRef);
		
		//Add it into the component map of the entity
		entityRef.components[$ newComponent.name] = newComponent;
		
		//Add it into the list of components this entity has
		array_push(entityRef.components.entity.components, newComponent);
		
		var system = world[$ newComponent.name];
		
		//Add it into the systems tracked component list
		array_push(system.componentList, newComponent);
		
		//TODO run create code when component is dynamically added?
		if(is_method(system.Create)) {
			system.Create(newComponent);
		}
		
		return newComponent;
	}
	
	function RemoveComponent(_entityId, _componentName)  {
		var entityRef = GetRef(_entityId);
		if(!entityRef) {
			show_debug_message(String("Tried from remove component '", _componentName,"' from non existant instance with id: ", _entityId));
			return;	
		}
		var componentToRemove = entityRef.components[$ _componentName];
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

	function SystemStep() {
		//Delete queued for deletion components
		var componentCount = array_length(componentRemoveQueue);
		var modifiedSystems = {};
		var systemsThatNeedCleaned = [];
		
		for(var i = 0; i < componentCount; i += 1) {
			var component = componentRemoveQueue[i];
			var entityRef = component.entityRef;
			var entityComp = entityRef.components.entity;
			
			
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
			variable_struct_remove(entityRef.components, component.name);
			component.entityRef = undefined;
			//Mark system components as dirty
			system.componentsDirty = true;
			//TODO: Can we actually delete this? Still in array list of system.
			//delete component;
		}
		array_resize(componentRemoveQueue, 0);

		//Delete queued instances
		var instanceCount = array_length(instanceRemoveQueue);
		for(var i = 0; i < instanceCount; i += 1) {
			var entityId = instanceRemoveQueue[i];
			var entityRef = GetRef(entityId);
			ds_map_delete(instances, entityId);
			//TODO: dont actually delete entities... could be struct or obj?
			//instance_destroy(inst, false);
			delete entityRef.components;
			entityRef.components = undefined;
			entityRef.world = undefined;
		}
		array_resize(instanceRemoveQueue, 0);
		
		//cleanup entity component arrays for systems
		var systemCount = array_length(systemsThatNeedCleaned);
		for(var i = 0; i < systemCount; i += 1) {
			var syst = systemsThatNeedCleaned[i];
			syst.CleanComponentList();
		}
	}
}