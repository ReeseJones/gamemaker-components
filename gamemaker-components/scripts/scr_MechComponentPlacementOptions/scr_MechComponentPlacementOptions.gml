struct_serialize_as(MechComponentPlacementOptions, nameof(MechComponentPlacementOptions));
function MechComponentPlacementOptions() constructor {
    position = new Vec2();
    orientation = 0;
    flipVertical = false;
    flipHorizontal = false;
}