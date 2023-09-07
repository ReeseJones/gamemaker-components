event_inherited();

event_add_listener(id, EVENT_DRAG_END, method(id, function(_button) {
    x = mouse_x;
    y = mouse_y;
}));

node_append_child(root_get(), id);