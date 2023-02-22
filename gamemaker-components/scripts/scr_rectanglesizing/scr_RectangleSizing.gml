/// @param {struct.Entity} _entity A reference to which thing this component is bound to.
function RectangleSizing(_entity) : Component(_entity) constructor {
    // Feather disable GM2017
    x = 0;
    y = 0;
    width = 64;
    height = 64;
    debug = true;
    debugCol = make_color_rgb(random(255), random(255), random(255));
    // Feather restore GM2017
}

/// @param {Struct.World} _world The world which this System operates in.
function RectangleSizingSystem(_world) : ComponentSystem(_world) constructor {
    static componentConstructor = RectangleSizing;
    static componentName = string_lowercase_first(script_get_name(componentConstructor));

    /// @param {Struct.RectangleSizing} _component
    /// @param {Real} _dt
    static drawGui = function draw_gui(_component, _dt) {
        if(_component.debug) {
            draw_set_color(_component.debugCol);
            draw_rectangle(_component.x, _component.y, _component.x + _component.width, _component.y + _component.height, true);
        }
    }
}
