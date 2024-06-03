struct_serialize_as( nameof(MechComponentPlacementOptions), MechComponentPlacementOptions);
function MechComponentPlacementOptions() constructor {
    position = new Vec2();
    orientation = 0;
    flipVertical = false;
    flipHorizontal = false;
}