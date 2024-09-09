event_inherited();

isDraggable = false;

sizeProperties = new ElementSizeDescription();
calculatedSize = new ElementSizeProperties();
calculateSizeCallback = ui_calculate_element_size;
drawElement = ui_element_draw;
enableStencil = false;


//TODO: We dont use this for custom ui
//TODO: this is for hit detection with mouse on in game objects
//object_set_size(id, width, height, spr_mask_rectangle);
