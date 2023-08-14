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
            var _newInst = instance_create_depth(
                random(room_width),
                random(room_height),
                _depthOrder,
                object_index
            );
            _newInst.depthOrder = _depthOrder;
        }
        
        instance_destroy();
    }
}

dragging = false;

onDragStart = function() {
    dragging = true;
}

onDragEnd = function(_dropTarget) {
    dragging = false;

    if(instance_exists(_dropTarget)) {
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
}