event_inherited();

onMouseOver = function() {
    image_blend = c_red;
}

onMouseOut = function() {
    image_blend = c_white;
}


onClicked = function(_button) {
    if(_button == mb_left) {
        x = random(room_width);
        y = random(room_height);
    } else if(_button == mb_right) {
        
        repeat(2) {
            var _depthOrder = round(random(10));
            var _newInst = instance_copy(true);
            _newInst.x = random(room_width);
            _newInst.y = random(room_height);
            _newInst.depth = _depthOrder;
            _newInst.depthOrder = _depthOrder;
        }
        
        instance_destroy();
    }
}

dragging = false;
randomCondition = choose(true, false);

onDragStart = function() {
    dragging = true;
    window_set_cursor(cr_handpoint);
}

onDragEnd = function(_dropTarget) {
    dragging = false;
    window_set_cursor(cr_default);
    if(instance_exists(_dropTarget) && _dropTarget.randomCondition) {
        _dropTarget.image_xscale += 0.2;
        _dropTarget.image_yscale += 0.2;
        instance_destroy();
    } else {
        x = mouse_x;
        y = mouse_y;
    }
    
}

onDragAbort = function() {
    dragging = false;
    window_set_cursor(cr_default);
}

onDropTargetChange = function(_dropTarget) {
    if(!instance_exists(_dropTarget)) {
        window_set_cursor(cr_handpoint);
        return;
    }
    
    if(_dropTarget.randomCondition) {
        window_set_cursor(cr_uparrow);
    } else {
        window_set_cursor(cr_hourglass);
    }
}