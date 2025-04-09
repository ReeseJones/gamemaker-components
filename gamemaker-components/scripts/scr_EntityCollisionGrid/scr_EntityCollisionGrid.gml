/// Do not use, just for autocomplete
function GridEntity() constructor {
    id = "";
    x = 0;
    y = 0;
    width = 1;
    height = 1;
}

/// @function EntityCollisionGrid
/// @param {Real}   _width
/// @param {Real}   _height
function EntityCollisionGrid(_width, _height) constructor {
    width = _width;
    height = _height;

    collisionGrid = ds_grid_create(width, height);
    idGrid = ds_grid_create(width, height);

    ds_grid_clear(collisionGrid, 0);
    ds_grid_clear(idGrid, undefined);

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
        ds_grid_clear(collisionGrid, 0);
        ds_grid_clear(idGrid, undefined);
    }

    /// @param {Struct.GridEntity}  _entity
    static addEntity = function(_entity) {
        if(!entityCanBePlaced(_entity)) {
            throw "Tried to place an entity where it cannot fit";
        }

        var _right = _x + _entity.width - 1;
        var _top = _y + _entity.height - 1;
        
        ds_grid_set_region(collisionGrid, _entity.x, _entity.y, _right, _top, 1);
        ds_grid_set_region(idGrid, _entity.x, _entity.y, _right, _top, _entity.id);
    }

    /// @function removeEntity
    /// @param {Struct.GridEntity} _entity
    static removeEntity = function(_entity) {
        var _left = _entity.x;
        var _bottom = _entity.y;
        var _right = _left + _entity.width - 1;
        var _top = _bottom + _entity.height - 1;
        ds_grid_set_region(collisionGrid, _left, _bottom, _right, _top, 0);
        ds_grid_set_region(idGrid, _left, _bottom, _right, _top, undefined);

    }

    /// @param {Struct.GridEntity} _entity
    static entityCanBePlaced = function(_entity) {
        var _x = _entity.x;
        var _y = _entity.y;

        //If the region is not in bounds it cannot be placed.
        if( !ds_grid_region_in_bounds(collisionGrid, _x, _y, _entity.width, _entity.height) ) {
            return false;
        }

        var _collisionVal = ds_grid_get_sum(collisionGrid, _x, _y, _x + _entity.width - 1, _y + _entity.height - 1);

        return _collisionVal < 1;
    }
    
    static dispose = function() {
        ds_grid_destroy(collisionGrid);
        collisionGrid = undefined;
        ds_grid_destroy(idGrid);
        idGrid = undefined;
        width = undefined;
        height = undefined;
    }

}