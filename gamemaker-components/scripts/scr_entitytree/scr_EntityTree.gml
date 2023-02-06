/// @desc EntityTree component creates a tree like relationship between entities.
/// @param {Struct} _entityRef A reference to the struct or game object that this entity represents.
function EntityTree(_entityRef) : Component(_entityRef) constructor {
    parent = undefined;
    children = [];
}

function EntityTreeSystem(_world) : ComponentSystem(_world) constructor {

    childTraversalQueue = ds_queue_create();
    
    registerSystemEvent(ES_SYSTEM_CLEANUP);
    function systemCleanup() {
        ds_queue_destroy(childTraversalQueue);
    }
    
    function SetParent(_childEntityId, _parentEntityId) {
        var childEntityRef = entity.getRef(_childEntityId);
        var parentEntityRef = _parentEntityId ? entity.getRef(_parentEntityId) : undefined;
        
        if(_childEntityId == _parentEntityId) {
            throw("Cannot parent entity to itself");    
        }
        
        if(is_undefined(childEntityRef)) {
            throw String("Child with id ", _childEntityId , " does not exist for setting the parent of");    
        }
        
        var childEntityTree = childEntityRef.components.entityTree;
        
        if(!childEntityTree) {
            throw String("Child with id ", _childEntityId, " does not have an entity tree component.");    
        }

        if(parentEntityRef) {
            var otherEntityTree = parentEntityRef.components.entityTree;
            if(!otherEntityTree) {
                throw(String("Entity with id ", _parentEntityId, " does not have EntityTree component and cant be set as a parent."));
            }
                
            array_push(otherEntityTree.children, _childEntityId);
        }
        
        var oldParentRef = entity.getRef(childEntityTree.parent);
        if(oldParentRef) {
            array_remove_first(oldParentRef.components.entityTree.children, _childEntityId);
        }

        childEntityTree.parent = _parentEntityId;
    }
    
    function AddChild(_entityId, _childEntityId) {
        SetParent(_childEntityId, _entityId);
    }
    
    //Removes entity from the tree
    function DisconnectFromTree(_entityId) {
        var entityRef = entity.getRef(_entityId);

        if(is_undefined(entityRef)) {
            throw String("Entity with id ", entityRef , " does not exist for DisconnectFromTree.");    
        }
        
        var entityTreeComp = entityRef.components.entityTree;
        
        if(is_undefined(entityTreeComp)) {
            throw String("Entity with id ", entityRef , " does not have an entity tree component, and cannot be dissconnected from the tree.");
        }
        
        //Disconnect parent
        var parentRef = entity.getRef(entityTreeComp.parent);        
        if(parentRef) {
            var parentEntityTree = parentRef.components.entityTree;
            if(is_undefined(parentEntityTree)) {
                throw String("While disconnecting ", _entityId, " from the tree, parent had no entityTreeComponent");    
            }
            array_remove_first(parentEntityTree.children, _entityId);
        }
        //Disconnect children
        array_foreach(entityTreeComp.children, function(_entityId) {
            var entityRef = entity.getRef(_entityId);
            entityRef.components.entityTree.parent = undefined;
        });
        
        entityTreeComp.parent = undefined;
        array_resize(entityTreeComp.children, 0);
    }
    
    
    //callback(entityRef, entityId)
    function ForeachEntityDown(_entityId, _callback, _skipSelf = false, _context = undefined) {
        ds_queue_clear(childTraversalQueue);
        if(_context) {
            _callback = method(_context, _callback);    
        }
        
        var queueEntity = function(_entityId) {
            ds_queue_enqueue(queue, _entityId);
        };
        
        var entityRef = entity.getRef(_entityId);
        var entityTree = entityRef.components.entityTree;
        if(_skipSelf) {
            array_foreach(entityTree.children, queueEntity, {queue: childTraversalQueue});
        } else {
            ds_queue_enqueue(childTraversalQueue, _entityId);
        }
        
        while(!ds_queue_empty(childTraversalQueue)) {
            var currentEntityId = ds_queue_dequeue(childTraversalQueue);
            var currentRef = entity.getRef(currentEntityId);
            var currentEntityTree = currentRef.components.entityTree;
            if(currentEntityTree) {
                array_foreach(currentEntityTree.children, queueEntity, {queue: childTraversalQueue});
                _callback(currentRef, currentEntityId);
            }
        }
    }
    
    function ForeachEntityUp(_entityId, _callback, _skipSelf = false, _context = undefined) {
        if(_context) {
            _callback = method(_context, _callback);    
        }
        
        var entityRef = entity.getRef(_entityId);
        var entityTree = entityRef.components.entityTree;
        if(_skipSelf) {
            _entityId = entityTree.parent;
        }
        
        while(_entityId) {
            var currentEntity = entity.getRef(_entityId);
            var currentEntityTree = currentEntity.components.entityTree;
            if(currentEntityTree) {
                _callback(currentEntity, _entityId);
                _entityId = currentEntityTree.parent;
            } else {
                _entityId = undefined;
            }
        }
    }
    
    function EntityDestroyTree(_entityId) {
        ForeachEntityDown(_entityId, function(_entityRef, _entityId) {
            entity.entityDestroy(_entityId);
        });
    }
    
    //TODO Cleanup events??!?
    function cleanup(_entityTree) { 
        var entityId = _entityTree.getEntityId();
        DisconnectFromTree(entityId);
    }
}