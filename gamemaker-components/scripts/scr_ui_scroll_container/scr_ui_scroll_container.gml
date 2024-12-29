function scroll_get_perpindicular_direction(_scrollDir) {
    switch(_scrollDir) {
        case flexpanel_flex_direction.row:
        case "row":
            return flexpanel_flex_direction.column;
        case flexpanel_flex_direction.row_reverse:
        case "row-reverse":
            return flexpanel_flex_direction.column_reverse;
        case flexpanel_flex_direction.column:
        case "column":
            return flexpanel_flex_direction.row;
        case flexpanel_flex_direction.column_reverse:
        case "column-reverse":
            return flexpanel_flex_direction.row_reverse;
        default: throw $"no direction: {_scrollDir}";
    }
}


///@param {Struct} _flexpanelStyle
function UIScrollContainer(_flexpanelStyle) : UIElement(_flexpanelStyle) constructor {
    scrollbarSize = 32;
    
    dragOffset = new Vec2();
    isHandleGrabbed = false;
    scrollDir = flexpanel_flex_direction.column;

    setAlignItems(flexpanel_align.stretch);
    
    spriteIndex = spr_bg_panel_blue_1;
    
    scrollbarContainer = new UIElement({
        name: "scrollbar container",
        alignItems: "stretch",
        flexBasis: scrollbarSize,
    });
    scrollbarContainer.spriteIndex = spr_bg_slate;
    
    scrollbarHandle = new UIElement({
        name: "scrollbar handle",
        flexBasis: scrollbarSize,
    });
    scrollbarHandle.spriteIndex = spr_bar_vertical_orange;
    
    contentAnchor = new UIElement({
        name: "scroll content anchor",
        flexGrow: 1,
    });
    
    contentWindow = new UIElement({
        name: "contentWindow",
        position: "absolute",
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        maxWidth: "100%",
        maxHeight: "100%",
    });
    
    contentContainer = new UIElement({
        name: "content container",
        alignItems: "stretch",
    });

    append(contentAnchor, scrollbarContainer);
    scrollbarContainer.append(scrollbarHandle);
    contentAnchor.append(contentWindow);
    contentWindow.append(contentContainer);

    onMouseMoveHandler = method(self, function(_mouseMoveEvent) {
        updateHandlePosition();
    });
    
    onDragStartHandler = method(self, function(_dragEvent) {
         isHandleGrabbed = true;
         dragOffset.x = device_mouse_x_to_gui(0) - scrollbarHandle.left;
         dragOffset.y = device_mouse_y_to_gui(0) - scrollbarHandle.top;
         show_debug_message($"Mouse Drag on handle at {dragOffset}"); 
         event_add_listener(obj_game.mouseManager, EVENT_MOUSE_MOVE, onMouseMoveHandler);
    });

    onDragEndHandler = method(self, function(_dragEvent) {
        show_debug_message($"released handle drag");
        isHandleGrabbed = false;
        event_remove_listener(obj_game.mouseManager, EVENT_MOUSE_MOVE, onMouseMoveHandler);
    });

    event_add_listener(scrollbarHandle, EVENT_PRESSED, onDragStartHandler);
    event_add_listener(obj_game.mouseManager, EVENT_RELEASED_GLOBAL, onDragEndHandler);
    
    ///@param {any} _scrollDirection
    static setScrollDirection = function(_scrollDirection) {
        scrollDir = _scrollDirection;
        var _perpDirection = scroll_get_perpindicular_direction(scrollDir);
        setFlexDirection(_perpDirection);
        //setCrossAxisSize(_scrollDirection, 100, flexpanel_unit.percent);
        
        //contentAnchor.setFlexDirection(scrollDir);
        contentContainer.setFlexDirection(scrollDir);

        scrollbarContainer.setFlexDirection(scrollDir);
        //scrollbarContainer.setFlexBasis(scrollbarSize, flexpanel_unit.point);
        
    }
    
    static updateHandlePosition = function () {
        var _isVert = scrollDir == flexpanel_flex_direction.column || scrollDir == flexpanel_flex_direction.column_reverse;
        var _size = _isVert ? contentWindow.height : contentWindow.width;
        var _contentSize = _isVert ? contentContainer.height : contentContainer.width;
        var _hiddenHeight = max(_contentSize - _size, 0);

        var _hiddenContentRatio = _hiddenHeight / _contentSize;
        var _scrollBarSize = (1 - _hiddenContentRatio) * _size;

        scrollbarHandle.setFlexBasis(_scrollBarSize, flexpanel_unit.point);
        
        if(_hiddenHeight == 0) {
            scrollbarHandle.setMargin(flexpanel_edge.all_edges, 0);
            contentContainer.setPosition(flexpanel_edge.all_edges,0, flexpanel_unit.point);
            return;
        }
        
        var _mouseGUIPosX = device_mouse_x_to_gui(0) - dragOffset.x;
        var _mouseGUIPosY = device_mouse_y_to_gui(0) - dragOffset.y;
        var _scrollPosX = _mouseGUIPosX - scrollbarContainer.left;
        var _scrollPosY = _mouseGUIPosY - scrollbarContainer.top;
        var _scrollMaxX = scrollbarContainer.width - scrollbarHandle.width;
        var _scrollMaxY = scrollbarContainer.height - scrollbarHandle.height

        _scrollPosX = clamp(_scrollPosX, 0, _scrollMaxX);
        _scrollPosY = clamp(_scrollPosY, 0, _scrollMaxY);

        scrollbarHandle.setMargin(flexpanel_edge.all_edges, 0); 
        scrollbarHandle.setMargin(flexpanel_edge.top, _isVert ? _scrollPosY : 0);
        scrollbarHandle.setMargin(flexpanel_edge.left, _isVert ? 0 : _scrollPosX);
        
        var _scrollPosPercent = _isVert ? _scrollPosY / _scrollMaxY : _scrollPosX / _scrollMaxX;
        var _scrollOffset = _hiddenHeight * _scrollPosPercent;
        
        contentContainer.setPosition(flexpanel_edge.left, _isVert ? 0 : -_scrollOffset, flexpanel_unit.point);
        contentContainer.setPosition(flexpanel_edge.top, _isVert ? -_scrollOffset : 0, flexpanel_unit.point);
    }
    
    setScrollDirection(scrollDir);
}