///@param {Struct.Entity} _entity
function UiRoot(_entity) : Component(_entity) constructor {
    static staticIntialization();

    focusedElement = undefined;
    cameraId = 0;
}

function UiRootSystem() : ComponentSystem() constructor {
    static componentConstructor = UiRoot;
    static staticIntialization();

    static beginStep = function(_uiRoot, _dt) {
        var _rectSizeComp = _uiRoot.instance.components.rectangleSizing;
        _rectSizeComp.x = 0;
        _rectSizeComp.y = 0;
        _rectSizeComp.width = display_get_gui_width();
        _rectSizeComp.height = display_get_gui_height();
    }
    
    static drawGui = function(_component, _dt) {
        if(_component.debug) {
            draw_set_color(_component.debugCol);
            draw_rectangle(_component.x, _component.y, _component.x + _component.width, _component.y + _component.height, true);
        }
    }
}
