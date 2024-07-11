event_inherited();

controlMode = MECH_CONTROL_MODE.EDIT;
component = new MechComponent("doodad01");
componentData = new MechComponentData(0, 1, 1, 0, []);
placement = new MechComponentPlacementOptions();
mechParent = undefined;

/*
event_add_listener(id, EVENT_MOUSE_OVER, method(id, function() {
    image_blend = c_red;
}));

event_add_listener(id, EVENT_MOUSE_OUT, method(id, function() {
    image_blend = c_white;
}));
*/

//event_add_listener(id, EVENT_CLICKED, method(id, mech_component_handle_on_clicked));