/// @description Insert description here
// You can write your code in this editor
event_inherited();

var _contentSize = contentContainer.calculatedSize;
var _isVert = contentContainer.sizeProperties.layout == ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
var _innerSize = _isVert ? _contentSize.innerHeight : _contentSize.innerWidth;
var _hiddenHeight = max(_contentSize.contentSize - _innerSize, 0);
var _scrollbarMovingSpaceRatio = _hiddenHeight / _contentSize.contentSize;
var _scrollBarSize = 1 - _scrollbarMovingSpaceRatio;
scrollbarHandle.sizeProperties.width = _isVert ? scrollbarSize : _scrollBarSize * _contentSize.width;
scrollbarHandle.sizeProperties.height = _isVert ? _scrollBarSize * _contentSize.height : scrollbarSize;

show_debug_message("scroll bar recalculating");