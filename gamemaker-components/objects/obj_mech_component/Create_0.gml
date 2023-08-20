event_inherited();

component = new MechComponent(2,2);
mechParent = undefined;
componentBinding = new MechComponentBinder(id, component);

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
