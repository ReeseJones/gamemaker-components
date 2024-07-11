///@param {string} _componentId // Id of a component this is the position for.
function MechComponentPosition(_componentId) constructor {
    // Reference to the component that this structure is describing the position of.
    id = _componentId;
    x = 0;
    y = 0;
    width = 1;
    height = 1;
    orientation = 0; //TODO: 0 = right, 1 = up, 2 = left, 3 = down ?
    flipVertical = false;
    flipHorizontal = false;
}