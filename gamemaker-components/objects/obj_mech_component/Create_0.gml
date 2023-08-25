event_inherited();

controlMode = MECH_CONTROL_MODE.EDIT;
component = new MechComponent(2,2);
componentBinding = new MechComponentBinder(id, component);
mechParent = undefined;

onMouseOver = function() {
    image_blend = c_red;
}

onMouseOut = function() {
    image_blend = c_white;
}


onClicked = function(_button) {

}


onDragStart = function() {

}

onDragEnd = function(_dropTarget) {

}

onDragAbort = function() {

}

onDropTargetChange = function(_dropTarget) {

}
