event_inherited();

//randomCondition
depth = -10
depthOrder = depth;


event_add_listener(id, EVENT_DRAG_END, method(id, function(_button) {
    x = mouse_x;
    y = mouse_y;
}));