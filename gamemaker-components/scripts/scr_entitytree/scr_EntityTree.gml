/// @desc EntityTree component creates a tree like relationship between entities.
/// @param {Struct} _entityRef A reference to the struct or game object that this entity represents.
function EntityTree(_entityRef) : Component(_entityRef) constructor {
    parent = undefined;
    children = [];
}

function EntityTreeSystem() : ComponentSystem() constructor {
     // Feather disable GM2017
    childTraversalQueue = ds_queue_create();
    // Feather restore GM2017

    static systemCleanup = function system_cleanup() {
        ds_queue_destroy(childTraversalQueue);
    }


/// @function        setParent(childEntityId, parentEntityId)
/// @description     Sets the parent of an entity making it part of an entity tree
/// @param {Real}    _childEntityId Id of the entity to be a child.
/// @param {Real}    _parentEntityId Id of the entity to be a parent.
    static setParent = function set_parent(_childEntityId, _parentEntityId) {
        var _childEntityRef = entity.getRef(_childEntityId);
        var _parentEntityRef = _parentEntityId ? entity.getRef(_parentEntityId) : undefined;
        
        if(_childEntityId == _parentEntityId) {
            throw("Cannot parent entity to itself");
        }

        if(is_undefined(_childEntityRef)) {
            throw string_join("", "Child with id ", _childEntityId , " does not exist for setting the parent of");    
        }

        var _childEntityTree = _childEntityRef.components.entityTree;

        if(!_childEntityTree) {
            throw string_join("", "Child with id ", _childEntityId, " does not have an entity tree component.");    
        }

        if(_parentEntityRef) {
            var _otherEntityTree = _parentEntityRef.components.entityTree;
            if(!_otherEntityTree) {
                throw(string_join("", "Entity with id ", _parentEntityId, " does not have EntityTree component and cant be set as a parent."));
            }

            array_push(_otherEntityTree.children, _childEntityId);
        }

        var _oldParentRef = entity.getRef(_childEntityTree.parent);
        if(_oldParentRef) {
            array_remove_first(_oldParentRef.components.entityTree.children, _childEntityId);
        }

        _childEntityTree.parent = _parentEntityId;
    }

/// @function        addChild(_entityId, _childEntityId)
/// @description     Adds a child to an entity tree
/// @param {Real}    _entityId Parent entity id.
/// @param {Real}    _childEntityId Child entity id.
    static addChild = function add_child(_entityId, _childEntityId) {
        setParent(_childEntityId, _entityId);
    }
    
/// @function       disconnectFromTree(entityId)
/// @description    Removes an entity from the entity tree that it is in.
/// @param {Real}   _entityId Entity Id to remove the entity tree that its in.
    static disconnectFromTree = function disconnect_from_tree(_entityId) {
        var _entityRef = entity.getRef(_entityId);

        if(is_undefined(_entityRef)) {
            throw string_join("", "Entity with id ", _entityRef , " does not exist for disconnectFromTree.");    
        }
        
        var _entityTreeComp = _entityRef.components.entityTree;
        
        if(is_undefined(_entityTreeComp)) {
            throw string_join("", "Entity with id ", _entityRef , " does not have an entity tree component, and cannot be dissconnected from the tree.");
        }
        
        //Disconnect parent
        var _parentRef = entity.getRef(_entityTreeComp.parent);        
        if(_parentRef) {
            var _parentEntityTree = _parentRef.components.entityTree;
            if(is_undefined(_parentEntityTree)) {
                throw string_join("", "While disconnecting ", _entityId, " from the tree, parent had no entityTreeComponent");    
            }
            array_remove_first(_parentEntityTree.children, _entityId);
        }
        //Disconnect children
        array_foreach(_entityTreeComp.children, function(_entityId) {
            var _entityRef = entity.getRef(_entityId);
            _entityRef.components.entityTree.parent = undefined;
        });
        
        _entityTreeComp.parent = undefined;
        array_resize(_entityTreeComp.children, 0);
    }
    
    
/// @function           foreachEntityDown(_entityId, _callback, _skipSelf = false)
/// @description        Runs callback on each entity in the tree.
/// @param {Real}       _entityId Starting entity from which to traverse down
/// @param {Function}   _callback Method which is called on each entity. callback(entity, entityId)
/// @param {Bool}       _skipSelf Whether to include the root entity in the traversal
    static foreachEntityDown = function foreach_entity_down(_entityId, _callback, _skipSelf = false) {
        ds_queue_clear(childTraversalQueue);
        
        var _queueEntity = method({queue: childTraversalQueue}, function(_entityId) {
            ds_queue_enqueue(queue, _entityId);
        });

        var _entityRef = entity.getRef(_entityId);
        var _entityTree = _entityRef.components.entityTree;
        if(_skipSelf) {
            array_foreach(_entityTree.children, _queueEntity);
        } else {
            ds_queue_enqueue(childTraversalQueue, _entityId);
        }
        
        while(!ds_queue_empty(childTraversalQueue)) {
            var _currentEntityId = ds_queue_dequeue(childTraversalQueue);
            var _currentRef = entity.getRef(_currentEntityId);
            var _currentEntityTree = _currentRef.components.entityTree;
            if(_currentEntityTree) {
                array_foreach(_currentEntityTree.children, _queueEntity);
                _callback(_currentRef, _currentEntityId);
            }
        }
    }

/// @function           foreachEntityUp(_entityId, _callback, _skipSelf = false)
/// @description        Runs a callback on each entity traversing up the tree.
/// @param {Real}       _entityId Starting entity from which to traverse down
/// @param {Function}   _callback Method which is called on each entity. callback(entity, entityId)
/// @param {Bool}       _skipSelf Whether to include the root entity in the traversal
    static foreachEntityUp = function foreach_entity_up(_entityId, _callback, _skipSelf = false) {
        var _entityRef = entity.getRef(_entityId);
        var _entityTree = _entityRef.components.entityTree;
        if(_skipSelf) {
            _entityId = _entityTree.parent;
        }
        
        while(_entityId) {
            var _currentEntity = entity.getRef(_entityId);
            var _currentEntityTree = _currentEntity.components.entityTree;
            if(_currentEntityTree) {
                _callback(_currentEntity, _entityId);
                _entityId = _currentEntityTree.parent;
            } else {
                _entityId = undefined;
            }
        }
    }
    
/// @function       entityDestroyTree(entityId)
/// @description    Marks every entity starting with EntityId and down for destruction. Anything above lives.
/// @param {Real}   _entityId Entity Id to remove the entity tree that its in.
    static entityDestroyTree = function entity_destroy_tree(_entityId) {
        foreachEntityDown(_entityId, function(_entityRef, _entityId) {
            entity.entityDestroy(_entityId);
        });
    }
    
/// @function       cleanup(entityTree)
/// @description    ComponentSystem cleanup event. Removes entities from the trees they are in.
/// @param {Struct.EntityTree}   _entityTree component to be cleaned up.
    static cleanup = function cleanup(_entityTree) { 
        var _entityId = _entityTree.getEntityId();
        disconnectFromTree(entityId);
    }
}