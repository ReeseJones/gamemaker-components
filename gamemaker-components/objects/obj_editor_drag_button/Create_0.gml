event_inherited();

//componentName = choose("doodad01", "doodad02", "doodad03", "doodad04", "doodad05", "doodad06");

event_add_listener(id, EVENT_MOUSE_OVER, method(id, function() {
    image_blend = c_red;
}));

event_add_listener(id, EVENT_MOUSE_OUT, method(id, function() {
    image_blend = c_white;
}));

event_add_listener(id, EVENT_CLICKED, method(id, function(_button) {
    if(_button == mb_left && object_index == obj_editor_drag_button) {
        //Create an instance of a mech component for testing
        var _newComponent = global.mechComponentFactory.createComponent(componentName);
        obj_mech.mechController.editorManager.beginPlacingComponent(obj_mech.id, _newComponent);
    }
}));
