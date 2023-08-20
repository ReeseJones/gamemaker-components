/// @function MechComponentGrid
/// @param {Real}   _width
/// @param {Real}   _height

function MechComponentGrid(_width, _height) constructor {
    width = _width;
    height = _height;
    
    collisionGrid = ds_grid_create(width, height);
    idGrid = ds_grid_create(width, height);
    componentMap = {};
    
    
    ds_grid_clear(collisionGrid, 0);
    
    /// @function grideSizeSet
    /// @param {Real}   _width
    /// @param {Real}   _height
    static grideSizeSet = function(_width, _height) {
        width = _width;
        height = _height;
        
        if(_width < 1 || _height < 1) {
            throw "Ensure mech grid created with proper size";
        }

        ds_grid_resize(collisionGrid, width, height);
        ds_grid_resize(idGrid, width, height);
    }
    
    /// @function addComponent
    /// @param {Real}   _x
    /// @param {Real}   _y
    /// @param {Struct.MechComponent}   _component
    static addComponent = function(_x, _y, _component) {
        if(!componentCanBePlaced(_x, _y, _component)) {
            throw "Tried to place a component where it cannot fit";
        }

        var _right = _x + _component.width - 1;
        var _top = _y + _component.height - 1;
        
        ds_grid_set_region(collisionGrid, _x, _y, _right, _top, 1);
        ds_grid_set_region(idGrid, _x, _y, _right, _top, _component.id);
    }
    
    /// @function removeComponent
    /// @param {Struct.MechComponent}   _component
    static removeComponent = function(_component) {
        if(!variable_struct_exists(componentMap, _component.id)) {
            throw "Cannot remove component which is not in the grid";
        }
        
        variable_struct_remove(componentMap, _component.id);
        
        var _right = _component.position.x + _component.width - 1;
        var _top = _component.position.y + _component.height - 1;
        ds_grid_set_region(collisionGrid, _x, _y, _right, _top, 0);
        ds_grid_set_region(idGrid, _x, _y, _right, _top, undefined);
    }
    
    /// @function componentCanBePlaced
    /// @param {Real}   _x
    /// @param {Real}   _y
    /// @param {Struct.MechComponent}   _component
    static componentCanBePlaced = function(_x, _y, _component) {
        
        //If the region is not in bounds it cannot be placed.
        if( !ds_grid_region_in_bounds(collisionGrid, _x, _y, _component.width, _component.height) ) {
            return false;
        }

        var _collisionVal = ds_grid_get_sum(collisionGrid, _x, _y, _x + _component.width - 1, _y + _component.height - 1);
        
        return _collisionVal < 1;
    }

}