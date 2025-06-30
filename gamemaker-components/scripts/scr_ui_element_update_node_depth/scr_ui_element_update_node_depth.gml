///@param {Struct.UIElement} _uiElement
function ui_element_update_depth_connections(_uiElement) {
    var _parent = _uiElement.parent();
    if(is_undefined(_parent)) {
        _uiElement.nodeDepth = 0;

        if(_uiElement.isConnected) {
            //TODO: send disconnected event
            _uiElement.isConnected = false;
            _uiElement.onDisconnected();
        }
        
        
    } else {
        _uiElement.nodeDepth = _parent.nodeDepth + 1;
        if(_parent.isConnected) {
            _uiElement.isConnected = true;
            _uiElement.onConnected();
        }
    }

    var _childCount = array_length(_uiElement.childNodes);
    for(var i = 0; i < _childCount; i += 1) {
        var _childNode = _uiElement.childNodes[i];
        ui_element_update_depth_connections(_childNode);
    }
}