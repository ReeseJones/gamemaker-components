///@param {Struct.ElementProperties} _scrollContainer
///@param {Constant.ELEMENT_LAYOUT_TYPE} _elementLayoutType
function ui_scroll_container_set_layout(_scrollContainer, _elementLayoutType) {
    with(_scrollContainer) {
        
        ui_mark_tree_recaculate(_scrollContainer);

        var _isVert = _elementLayoutType == ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
        // Scroll container makes room for scrollbar // vertical scroll container means lay out content left to right horizontaly
        sizeProperties.layout =  _isVert ? ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL : ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
        //scrollPosition = 0; // A number from 0 to 1

        scrollbarContainer.sizeProperties.width = _isVert ? scrollbarSize : 1;
        scrollbarContainer.sizeProperties.height = _isVert ? 1 : scrollbarSize;
        scrollbarContainer.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.MANUAL;

        scrollbarHandle.image_angle = _isVert ? 0 : 90;
        scrollbarHandle.sizeProperties.position.left = 0;
        scrollbarHandle.sizeProperties.position.top = 0;

        contentContainer.sizeProperties.layout = _isVert ? ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL : ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;
        contentContainer.sizeProperties.width = _isVert ? undefined : undefined;
        contentContainer.sizeProperties.height = _isVert ? undefined : undefined;
        contentContainer.calculatedSize.childOffset.x = 0;
        contentContainer.calculatedSize.childOffset.y = 0;
        alarm_set(10, 1);
    }
}