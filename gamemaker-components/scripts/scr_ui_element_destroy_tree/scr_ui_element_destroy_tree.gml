//Removes an element from a tree and calls all removed nodes dipsose function
///@param {Struct.UIElement} _uiElement
function ui_element_destroy_tree(_uiElement) {
    
    if( !is_instanceof(_uiElement, UIElement) ) {
        throw "ui_element_destroy_tree was passed an object that was not a UIElement";
    }
    
    _uiElement.remove();
    
    ui_element_foreach(_uiElement, method(undefined, function(_el) {
        _el.disposeFunc();
    }), true);
}