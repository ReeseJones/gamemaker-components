enum DRAG_STATE {
    IDLE,
    INITIATE,
    IN_PROGRESS,
}

///@param {string} _type
///@param {Any} _data
///@param {Constant.MouseButton} _mouseButton
function MouseEvent(_type, _data, _mouseButton) : EventData(_type, _data) constructor {
    mouseButton = _mouseButton;
}


///@param {Struct.LoggingService} _logger
function MouseManager(_logger) : EventNode()  constructor {
    logger = _logger
    //TODO: Destroy this list
    instanceHoverList = ds_priority_create();

    state = DRAG_STATE.IDLE;

    dragStartDistance = 48;
    dragStartPosition = {x: 0, y: 0};

    dragButton = undefined;
    dragTarget = undefined;

    hoverTarget = undefined;

    clickButton = undefined;
    clickTarget = undefined;

    globalMouseInputList = [mb_left, mb_right, mb_middle, mb_side1, mb_side2];

/// @function        dragInitiate()
/// @description start the logic for detecting a drag action for clickable elements
/// @param {Constant.MouseButton}    _button
    static dragInitiate = function(_button) {
        logger.log(LOG_LEVEL.INFORMATIONAL, $"Possibly starting drag on {hoverTarget}");
        state = DRAG_STATE.INITIATE;
        dragTarget = hoverTarget;
        dragButton = _button;
        dragStartPosition.x = device_mouse_x_to_gui(0);
        dragStartPosition.y = device_mouse_y_to_gui(0);
    }

/// @function checkForDragStart
/// @description encapsulates the logic for checking if a drag has started
    static checkForDragStart = function() {
        var _mouseX = device_mouse_x_to_gui(0);
        var _mouseY = device_mouse_y_to_gui(0);
        var _dist = point_distance(dragStartPosition.x, dragStartPosition.y, _mouseX, _mouseY);

        if(_dist > dragStartDistance) {
            //We are now in a drag
            state = DRAG_STATE.IN_PROGRESS
            logger.log(LOG_LEVEL.INFORMATIONAL, $"Starting drag on {dragTarget}");
            event_dispatch(dragTarget, new MouseEvent(EVENT_DRAG_START, dragTarget, dragButton));
        }
    }

    static resetDragState = function() {
        state = DRAG_STATE.IDLE;
        dragTarget = undefined;
        dragButton = undefined;
    }

    static abortDrag = function() {
        if(state == DRAG_STATE.IN_PROGRESS) {
            logger.log(LOG_LEVEL.INFORMATIONAL, $"In progress drag cancelled on {dragTarget}");
            event_dispatch(dragTarget, new MouseEvent(EVENT_DRAG_ABORT, dragTarget, dragButton));
        }
        resetDragState();
    }

/// @function update()
/// @description update runs the logic for detecting drag actions and sending appropriate drag events.
    static update = function() {
        switch(state) {
            case DRAG_STATE.INITIATE: {
                checkForDragStart();
            } break;

            case DRAG_STATE.IN_PROGRESS: {

            } break;

            default:
        }

        var _mbCount = array_length(globalMouseInputList);
        for(var i = 0; i < _mbCount; i += 1) {
            var _button = globalMouseInputList[i];

            if( device_mouse_check_button_pressed(0, _button)) {
                handleGlobalPressed(_button);
            }

            if( device_mouse_check_button_released(0, _button)) {
                handleGlobalReleased(_button);
            }
        }
    }

/// @function handleGlobalPressed
/// @description handles global mouse input to start clicks and fire events to UI
/// @param {Constant.MouseButton}    _button
    static handleGlobalPressed = function(_button) {
        clickTarget = undefined;
        clickButton = _button;

        if(state != DRAG_STATE.IDLE && _button != dragButton) {
            abortDrag();
        }

        if(!is_undefined(hoverTarget) && instance_exists(hoverTarget)) {
            clickTarget = hoverTarget;
            
            logger.log(LOG_LEVEL.INFORMATIONAL, $"Performing on press of {hoverTarget}");
            event_dispatch(hoverTarget, new MouseEvent(EVENT_PRESSED, hoverTarget, _button));

            if(hoverTarget.isDraggable) {
                dragInitiate(_button);
            }
        }
    }

/// @function handleGlobalReleased
/// @description handles global mouse input to start clicks and fire events to UI
/// @param {Constant.MouseButton}    _button
    static handleGlobalReleased = function(_button) {
         if(state == DRAG_STATE.IN_PROGRESS && _button == dragButton) {
            logger.log(LOG_LEVEL.INFORMATIONAL, $"Completing drag starting at {dragTarget} and ending at {hoverTarget}");

            var _dropTarget = hoverTarget;
            event_dispatch(dragTarget, new MouseEvent(EVENT_DRAG_END, _dropTarget, _button));

            resetDragState();
        } else {
            abortDrag();
        }

        event_dispatch(self, new MouseEvent(EVENT_RELEASED_GLOBAL, _button, _button));

        if(!is_undefined(hoverTarget) && instance_exists(hoverTarget)) {
            var _isClickTarget = clickTarget == hoverTarget;
            var _sameButton = clickButton == _button;
            
            logger.log(LOG_LEVEL.INFORMATIONAL, $"Performing on release of {hoverTarget}");

            event_dispatch(hoverTarget, new MouseEvent(EVENT_RELEASED, _button, _button));

            if(_isClickTarget && _sameButton) {
                logger.log(LOG_LEVEL.INFORMATIONAL, $"Performing on Clicked of target {hoverTarget.id}");
                event_dispatch(hoverTarget, new MouseEvent(EVENT_CLICKED, _button, _button));
            }
        }
    }

    static handleInstanceMouseOver = function(_instanceRef) {
        /*
        if(!object_is_ancestor(_instanceRef.object_index, obj_clickable)) {
            logger.log(LOG_LEVEL.IMPORTANT, "WARNING: handling MouseOver on non clickable object")
            return;
        }*/

        ds_priority_add(instanceHoverList, _instanceRef, _instanceRef.nodeDepth);

        updateHoveredInstance();
    }

    static handleInstanceMouseOut = function(_instanceRef) {
        /*if(!object_is_ancestor(_instanceRef.object_index, obj_clickable)) {
            logger.log(LOG_LEVEL.IMPORTANT, "WARNING: handling MouseOut on non clickable object")
            return;
        }*/

        ds_priority_delete_value(instanceHoverList, _instanceRef);

        updateHoveredInstance();
    }

    static updateHoveredInstance = function() {
        var _oldHoverTarget = hoverTarget;
        var _currentHoverTarget = ds_priority_find_max(instanceHoverList);

        // if the hover target is unchanged we can stop early, no need to notify.
        if(_currentHoverTarget == _oldHoverTarget) {
            return;
        }

        //update hover target
        hoverTarget = _currentHoverTarget;

        //If the old hover target exists notify that its not hoverd object
        if(_oldHoverTarget) {
            _oldHoverTarget.mouseIsOver = false;
            event_dispatch(_oldHoverTarget, new EventData(EVENT_MOUSE_OUT, _oldHoverTarget));
        }

        //if the new hover target exists notify that it IS hovered object
        if(_currentHoverTarget) {
            _currentHoverTarget.mouseIsOver = true;
            event_dispatch(_currentHoverTarget, new EventData(EVENT_MOUSE_OVER, _currentHoverTarget));
        }

        //TODO: Drag targets always instances? possibly...
        if(state == DRAG_STATE.IN_PROGRESS && instance_exists(dragTarget)) {
            event_dispatch(dragTarget, new EventData(EVENT_DRAG_DROP_TARGET_CHANGE, _currentHoverTarget));
        }
    }
}

//TODO: global mouse manager? Service binding?
/// @description handles local mouse over events for the ui stack
/// @param {Id.Instance}    _instanceRef
function mouse_manager_handle_mouse_over(_instanceRef) {
    if(instance_exists(obj_game)) {
        obj_game.mouseManager.handleInstanceMouseOver(_instanceRef);
    } else {
        throw "create a mouse manager!!!";
    }
}

/// @description handles local mouse out events for the ui stack
/// @param {Id.Instance}    _instanceRef
function mouse_manager_handle_mouse_out(_instanceRef) {
    if(instance_exists(obj_game)) {
        obj_game.mouseManager.handleInstanceMouseOut(_instanceRef);
    } else {
        throw "create a mouse manager!!!";
    }
}
