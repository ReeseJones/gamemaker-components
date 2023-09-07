/// @function MechEditorManager()
function MechEditorManager() constructor {
    component = undefined;
    placementTarget = undefined;

    /// @function beginPlacingComponent()
    /// @param {Id.Instance}   _mech
    /// @param {Id.Instance}   _component
    static beginPlacingComponent = function(_mech, _component) {
        if(!is_undefined(component)) {
            throw "Must finish placing a component before starting another placement";
        }

        component = _component;
        placementTarget = _mech;
        component.mechParent = _mech;
        var _compData = _component.component;

        if(placementTarget.mechComponentGrid.componentInGrid(_compData)) {
            placementTarget.mechComponentGrid.removeComponent(_compData);
        }
    }

    /// @function endPlacingComponent()
    /// @param {Id.Instance}   _mech
    /// @param {Id.Instance}   _component
    static endPlacingComponent = function(_mech, _component) {
        var _compData =  component.component;
        if(placementTarget.mechComponentGrid.componentCanBePlaced(_compData.position.x, _compData.position.y, _compData)) {
            placementTarget.mechComponentGrid.addComponent(_compData.position.x, _compData.position.y, _compData);
            component = undefined;
            placementTarget = undefined;
        }

    }

    static isPlacingComponent = function() {
        return !is_undefined(component);
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
        
        var _gridPosX = round(_relX / MECH_CELL_SIZE - ((component.component.width & 1) * 0.5));
        var _gridPosY = round(_relY / MECH_CELL_SIZE - ((component.component.height & 1) * 0.5));

        var _finalCellPosX = _gridPosX - floor(component.component.width / 2);
        var _finalCellPosY = _gridPosY - floor(component.component.height / 2);

        // Assign cell position
        component.component.position.x = _finalCellPosX;
        component.component.position.y = _finalCellPosY;
        
        // Assign world position
        component.x = mech_system_grid_cell_position_x(placementTarget.mechSystem, _finalCellPosX) + (component.component.width / 2 * MECH_CELL_SIZE);
        component.y = mech_system_grid_cell_position_y(placementTarget.mechSystem, _finalCellPosY) + (component.component.height / 2 * MECH_CELL_SIZE);
    }
}