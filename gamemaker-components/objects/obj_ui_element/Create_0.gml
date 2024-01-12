event_inherited();

isDraggable = false;


// A width equal to or less than 1.0 is interpreted as a percentage of the parents size
// A number greater than or equal to 2 is interpreted as a gui pixel size
// Undefined means something else calculates size
width = 1; // 0.0 - 1.0 | N >= 2 | undefined
height = 1;
calculatedWidth = 0;
calculatedHeight = 0;
object_set_size(id, width, height, spr_mask_rectangle);

overflowHorizontal = OVERFLOW_TYPE.VISIBLE;
overflowVertical = OVERFLOW_TYPE.SCROLL

