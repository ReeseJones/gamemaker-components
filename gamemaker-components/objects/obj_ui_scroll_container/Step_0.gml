/// @description Insert description here
// You can write your code in this editor
if( isHandleGrabbed ) {
    scrollbarHandle.calculatedSize.position.left = clamp(device_mouse_x_to_gui(0) - dragOffset.x, scrollbarContainer.calculatedSize.position.left, scrollbarContainer.calculatedSize.position.right - scrollbarSize);
    scrollbarHandle.calculatedSize.position.top = clamp(device_mouse_y_to_gui(0) - dragOffset.y, scrollbarContainer.calculatedSize.position.top, scrollbarContainer.calculatedSize.position.bottom - scrollbarSize * 2);
    scrollbarHandle.calculatedSize.position.right = scrollbarHandle.calculatedSize.position.left + scrollbarHandle.calculatedSize.width;
    scrollbarHandle.calculatedSize.position.bottom = scrollbarHandle.calculatedSize.position.top + scrollbarHandle.calculatedSize.height;
    /*node_foreach_parent(scrollbarHandle, function(_node) {
        _node.calculatedSize.needsRecalculated = true;
    });*/
}