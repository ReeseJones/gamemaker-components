/// @function MechEditorManager()
function MechEditorManager() constructor {
    component = undefined;
    placementTarget = undefined;

    /// @function beginPlacingComponent()
    /// @param {Id.Instance}   _mech
    /// @param {Id.Instance}   _component
    static beginPlacingComponent = function(_mech, _component) {
        component = _component;
        placementTarget = _mech;
    }

    /// @function endPlacingComponent()
    /// @param {Id.Instance}   _mech
    /// @param {Id.Instance}   _component
    static endPlacingComponent = function(_mech, _component) {
        component = undefined;
        placementTarget = undefined;
    }
  
    static update = function() {
        if(is_undefined(component)) {
            return;
        }

        //TODO Getting grid position then getting component relative position to start moving it
        var _gridX = mech_system_grid_cell_position_x(placementTarget.mechSystem, 0);
        var _gridY = mech_system_grid_cell_position_y(placementTarget.mechSystem, 0);
        var _relX = mouse_x - _gridX;
        var _relY = mouse_y - _gridY;


        var _gridPosX = round(_relX / MECH_CELL_SIZE);
        var _gridPosY = round(_relY / MECH_CELL_SIZE);

        var _xSnap = _gridPosX * MECH_CELL_SIZE;
        var _ySnap = _gridPosX * MECH_CELL_SIZE;

        component.component.position.x = _gridPosX - floor(component.component.width / 2); 
        component.component.position.y = _gridPosY - floor(component.component.height / 2);

    }
}