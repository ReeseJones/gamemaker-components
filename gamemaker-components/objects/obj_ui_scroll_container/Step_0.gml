/*var _contentSize = contentContainer.calculatedSize;
var _isVert = contentContainer.sizeProperties.layout == ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
var _innerSize = _isVert ? _contentSize.innerHeight : _contentSize.innerWidth;
var _hiddenHeight = max(_contentSize.contentSize - _innerSize, 0);
var _scrollbarMovingSpaceRatio = _hiddenHeight / _contentSize.contentSize;
var _scrollBarSize = 1 - _scrollbarMovingSpaceRatio;
scrollbarHandle.sizeProperties.width = _isVert ? scrollbarSize : _scrollBarSize * _contentSize.width;
scrollbarHandle.sizeProperties.height = _isVert ? _scrollBarSize * _contentSize.height : scrollbarSize;
*/
//scrollbarHandle.calculatedSize.needsRecalculated = true;
//ui_calculate_layout(scrollbarHandle);

//show_debug_message($"1: _contentSize.contentSize: {_contentSize.contentSize}");
///show_debug_message($"1: innerSize: {_innerSize}");
//show_debug_message($"2: _hiddenHeight: {_hiddenHeight}");
//show_debug_message($"3: _scrollbarMovingSpaceSize: {_scrollbarMovingSpaceSize}");
//show_debug_message($"4: _scrollBarSize: {_scrollBarSize}");


/// @description Insert description here
// You can write your code in this editor
if( isHandleGrabbed ) {
    var _contentSize = contentContainer.calculatedSize;
    var _isVert = contentContainer.sizeProperties.layout == ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    var _innerSize = _isVert ? _contentSize.innerHeight : _contentSize.innerWidth;
    var _hiddenHeight = max(_contentSize.contentSize - _innerSize, 0);
    var _scrollbarMovingSpaceRatio = _hiddenHeight / _contentSize.contentSize;
    var _scrollBarSize = 1 - _scrollbarMovingSpaceRatio;
    scrollbarHandle.sizeProperties.width = _isVert ? scrollbarSize : _scrollBarSize * _contentSize.width;
    scrollbarHandle.sizeProperties.height = _isVert ? _scrollBarSize * _contentSize.height : scrollbarSize;
    
    var _mouseGUIPosX = device_mouse_x_to_gui(0) - dragOffset.x;
    var _mouseGUIPosY = device_mouse_y_to_gui(0) - dragOffset.y;
    var _scrollPosX = _mouseGUIPosX - scrollbarContainer.calculatedSize.position.left;
    var _scrollPosY = _mouseGUIPosY - scrollbarContainer.calculatedSize.position.top;


    _scrollPosX = clamp(_scrollPosX, 0, scrollbarContainer.calculatedSize.width - scrollbarHandle.calculatedSize.width);
    _scrollPosY = clamp(_scrollPosY, 0, scrollbarContainer.calculatedSize.height - scrollbarHandle.calculatedSize.height);
    scrollbarHandle.sizeProperties.position.left = _scrollPosX;
    scrollbarHandle.sizeProperties.position.top = _scrollPosY;
    
    // This prevents it being a number from 0 to 1
    scrollbarHandle.sizeProperties.position.left = scrollbarHandle.sizeProperties.position.left <= 1 ? 0 : scrollbarHandle.sizeProperties.position.left;
    scrollbarHandle.sizeProperties.position.top = scrollbarHandle.sizeProperties.position.top <= 1 ? 0 : scrollbarHandle.sizeProperties.position.top;
    
    var _scrollBarMovingSpace = _scrollbarMovingSpaceRatio * _innerSize;
    var _scrollPosPercent = _isVert ? _scrollPosY / _scrollBarMovingSpace : _scrollPosX / _scrollBarMovingSpace;
    var _scrollOffset = _hiddenHeight *_scrollPosPercent;
    //show_debug_message($"Scroll Percent: {_scrollPosPercent} ScrollOffset: {_scrollOffset}");

    ui_mark_tree_recaculate(id);

    contentContainer.calculatedSize.childOffset.x = _isVert ? 0 : -_scrollOffset;
    contentContainer.calculatedSize.childOffset.y = _isVert ? -_scrollOffset : 0;

    //show_debug_message($"3: left: {contentContainer.sizeProperties.position.left}");
    //show_debug_message($"4: top: {contentContainer.sizeProperties.position.top}");
}