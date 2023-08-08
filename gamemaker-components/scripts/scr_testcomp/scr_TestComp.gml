function TestComp(_instance) : Component(_instance) constructor {
    timer = 0;
}

function TestCompSystem() : ComponentSystem() constructor {
    static componentConstructor = TestComp;
    static componentName = string_lowercase_first(script_get_name(componentConstructor));
    
    
    static onCreate = function(_component) {
        show_debug_message("TestComponent Created!");
    }
    
    static step = function(_component, _dt) {
        _component.timer += 1;

        if(_component.timer % 60 == 0) {
            show_debug_message("tick!!!");
        }

        if(_component.timer > 180) {
            //entity.entityDestroy(_component.getEntityId());
        }

        var _rectSizeComp = _component.instance.components.rectangleSizing;

        if(_rectSizeComp) {
            _rectSizeComp.width = display_get_gui_width()  * abs(cos(_component.timer / 10));
            _rectSizeComp.height = display_get_gui_height()  * abs(sin((_component.timer + 1.5) / 10));
        }
    }
    
    static destroy = function destroy(_component) {
        show_debug_message("TestComponent Destroyed!");
    }
    
    static cleanup = function cleanup(_component) {
        show_debug_message("TestComponent Cleaned up!");
    }
}