event_inherited();

isDraggable = false;

sizeProperties = new ElementSizeDescription();
calculatedSize = new ElementSizeProperties();
calculateSizeCallback = ui_calculate_element_size;
drawElement = ui_element_draw;
enableStencil = true;

///Scroll related properties
scrollbarSize = 32;
sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;
scrollPosition = 0; // A number from 0 to 1

scrollbarContainer = instance_create_depth(0, 0, depth, obj_ui_element);
scrollbarContainer.sprite_index = spr_bg_slate;
scrollbarContainer.visible = true;

scrollbarHandle = instance_create_depth(0, 0, depth, obj_ui_element);
scrollbarHandle.sprite_index = spr_bar_vertical_orange;
scrollbarHandle.visible = true;

contentContainer = instance_create_depth(0, 0, depth, obj_ui_element);
contentContainer.visible = false;

ui_scroll_container_set_layout(id, ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL);

node_append_child(id, contentContainer);
node_append_child(id, scrollbarContainer);
node_append_child(scrollbarContainer, scrollbarHandle);


//TODO: We dont use this for custom ui
//TODO: this is for hit detection with mouse on in game objects
//object_set_size(id, width, height, spr_mask_rectangle);

// Content Height - the size of the content
// AvailableHeight - The size of the space to show content
// Hidden Height = Content Height - AvailableHeight
// ScrollbarMovingSpaceHeight = hiddenHeight / Content Height
// ScrollbarHeightPercent: 1 - ScrollbarMovingSpaceHeight
