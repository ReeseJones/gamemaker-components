event_inherited();

isDraggable = false;

sizeProperties = new ElementSizeDescription();
calculatedSize = new ElementSizeProperties();
calculateSizeCallback = ui_calculate_element_size;
drawElement = ui_element_draw;
enableStencil = true;

// Scroll Content on left/top, scrollbar on side/bottom
sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;

///Scroll related properties
scrollbarSize = 32;
scrollPosition = 0; // A number from 0 to 1
dragOffset = new Vec2();
isHandleGrabbed = false;

scrollbarContainer = instance_create_depth(0, 0, depth, obj_ui_element);
scrollbarContainer.sprite_index = spr_bg_slate;
scrollbarContainer.visible = true;

scrollbarHandle = instance_create_depth(0, 0, depth, obj_ui_element);
scrollbarHandle.sprite_index = spr_bar_vertical_orange;
scrollbarHandle.visible = true;
scrollbarHandle.isDraggable = true;

contentContainer = instance_create_depth(0, 0, depth, obj_ui_element);
contentContainer.visible = false;

ui_scroll_container_set_layout(id, ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL);

node_append_child(id, contentContainer);
node_append_child(id, scrollbarContainer);
node_append_child(scrollbarContainer, scrollbarHandle);

onDragStartHandler = method(id, function(_dragEvent) {
    isHandleGrabbed = true;
    dragOffset.x = device_mouse_x_to_gui(0) - scrollbarHandle.calculatedSize.position.left;
    dragOffset.y = device_mouse_y_to_gui(0) - scrollbarHandle.calculatedSize.position.top;
    show_debug_message($"Mouse pressed on handle at {dragOffset}");
});

onDragEndHandler = method(id, function(_dragEvent) {
    show_debug_message($"released handle");
    isHandleGrabbed = false;
});

event_add_listener(scrollbarHandle, EVENT_PRESSED, onDragStartHandler);
event_add_listener(root_get().mouseManager, EVENT_RELEASED_GLOBAL, onDragEndHandler);


//TODO: We dont use this for custom ui
//TODO: this is for hit detection with mouse on in game objects
//object_set_size(id, width, height, spr_mask_rectangle);

// Content Height - the size of the content
// AvailableHeight - The size of the space to show content
// Hidden Height = Content Height - AvailableHeight
// ScrollbarMovingSpaceHeight = hiddenHeight / Content Height
// ScrollbarHeightPercent: 1 - ScrollbarMovingSpaceHeight
