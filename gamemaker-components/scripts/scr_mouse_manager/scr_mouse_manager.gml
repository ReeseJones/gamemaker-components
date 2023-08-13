enum DRAG_STATE {
    INITIATE,
    IN_PROGRESS,
    END,
    IDLE
}

function MouseManager() constructor {
    //TODO: Destroy this list
    instanceHoverList = ds_priority_create();

    state = DRAG_STATE.IDLE;
    payload = undefined;
    dragStartDistance = 16;
    dragStartPosition = {x: 0, y: 0};
    dragTarget = undefined;
    dropTarget = undefined;
    hoverTarget = undefined;
    clickTarget = undefined;

    static dragIntiate = function() {
        if(is_undefined(hoverTarget)) {
            return;
        }

        state = DRAG_STATE.INITIATE;
        dragTarget = hoverTarget;
        dragStartPosition.x = mouse_x;
        dragStartPosition.y = mouse_y;
    }
    
    static update = function() {
        switch(state) {
            case DRAG_STATE.INITIATE: {
                checkForDragStart();
            } break;
            case DRAG_STATE.IN_PROGRESS: {
                checkForDragTargets();
            } break;
            default:
        }
    }
    
    static checkForDragStart = function() {
        var _dist = point_distance(dragStartPosition.x, dragStartPosition.y, mouse_x, mouse_y);
        
        if(_dist > dragStartDistance) {
            dragStart();
        }
    }
    
    static checkForDragTargets = function() {
        //while drag is in progress check for drop target updates
    }
    
    static dragStart = function() {
        state = DRAG_STATE.IN_PROGRESS;
        //TODO: fire drag start event on drag target
    }
    
    static handleGlobalLeftPressed = function() {
        //dragIntiate();
        clickTarget = undefined;

        if(!is_undefined(hoverTarget) && instance_exists(hoverTarget)) {
            clickTarget = hoverTarget;
            with(hoverTarget) {
                onPressed();
            }
        }
    }

    static handleGlobalLeftReleased = function() {
        if(!is_undefined(hoverTarget) && instance_exists(hoverTarget)) {
            var _isClickTarget = clickTarget == hoverTarget;
            
            with(hoverTarget) {
                onReleased();
                if(_isClickTarget) {
                    onClicked();
                }
            }
        }
    }

    static handleInstanceMouseOver = function(_instanceRef) {
        if(!object_is_ancestor(_instanceRef.object_index, obj_clickable)) {
            show_debug_message("WARNING: handling MouseOver on non clickable object")
            return;
        }

        ds_priority_add(instanceHoverList, _instanceRef, _instanceRef.depthOrder);

        updateHoveredInstance();
    }
    
    static handleInstanceMouseOut = function(_instanceRef) {
        if(!object_is_ancestor(_instanceRef.object_index, obj_clickable)) {
            show_debug_message("WARNING: handling MouseOut on non clickable object")
            return;
        }

        ds_priority_delete_value(instanceHoverList, _instanceRef);

        updateHoveredInstance();
    }
    
    static updateHoveredInstance = function() {
        var _oldHoverTarget = hoverTarget;
        var _currentHoverTarget = ds_priority_find_min(instanceHoverList);

        // if the hover target is unchanged we can stop early, no need to notify.
        if(_currentHoverTarget == _oldHoverTarget) {
            return;
        }

        //update hover target
        hoverTarget = _currentHoverTarget;

        //If the old hover target exists notify that its not hoverd object
        if(_oldHoverTarget) {
            ////TODO: notify mouse out
            //show_debug_message($"mouse out of {_oldHoverTarget}");
            with(_oldHoverTarget) {
                onMouseOut();
            }
        }
        
        //if the new hover target exists notify that it IS hovered object
        if(_currentHoverTarget) {
            //TODO: noitfy mouse over
            //show_debug_message($"mouse in to {_currentHoverTarget}");
            with(_currentHoverTarget) {
                onMouseOver();
            }
        }
    }
}

function mouse_manager_handle_mouse_over(_instanceRef) {
    if(instance_exists(obj_mouse_manager)) {
        obj_mouse_manager.mouseManager.handleInstanceMouseOver(_instanceRef);
    }
}

function mouse_manager_handle_mouse_out(_instanceRef) {
    if(instance_exists(obj_mouse_manager)) {
        obj_mouse_manager.mouseManager.handleInstanceMouseOut(_instanceRef);
    }
}
