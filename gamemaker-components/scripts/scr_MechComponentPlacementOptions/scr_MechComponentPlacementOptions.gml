struct_save_static( nameof(MechComponentPlacementOptions), MechComponentPlacementOptions);
function MechComponentPlacementOptions() constructor {
    x = 0;
    y = 0;
    orientation = 0; //TODO: 0 = right, 1 = up, 2 = left, 3 = down ?
    flipVertical = false;
    flipHorizontal = false;
}