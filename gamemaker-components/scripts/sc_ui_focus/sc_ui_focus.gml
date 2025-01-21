function ui_focus(_element) {
    
    if(_element != undefined && !is_instanceof(_element, UIElement)) {
        throw "_element is not an instance of UIElement";
    }
    var _prevFocus = obj_game.focus;
    obj_game.focus = _element;
    
    
    if(_element == _prevFocus) {
        return;
    }
    
    //TODO: Send focus change to previously focused element
    
    var _ev = new EventData(EVENT_FOCUS_CHANGED, {
        currentFocus: _element,
        previousFocus: _prevFocus,
    });
    

    event_dispatch(obj_game.id, _ev);
    
    show_debug_message($"Focused {_element}");
}