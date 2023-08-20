/// @function        ds_grid_draw(_dsGridId, _x, _y, _cellSize)
/// @param {Id.DsGrid}    _dsGridId Id of the grid to draw
/// @param {Real}    _x Where to start drawing the grid from
/// @param {Real}    _y Where to start drawing the grid from.
/// @param {Real}    _cellSize size of the cells 
function ds_grid_draw(_dsGridId, _x, _y, _cellSize = 16) {
    var _gridWidth = ds_grid_width(_dsGridId);
    var _gridHeight = ds_grid_height(_dsGridId);
    
    draw_grid(_x, _y, _cellSize, _cellSize, _gridWidth, _gridHeight);
}

/// @function        ds_grid_region_in_bounds(_dsGridId, _x, _y, _width, _height)
/// @param {Id.DsGrid}    _dsGridId
/// @param {Real}    _x
/// @param {Real}    _y
/// @param {Real}    _width
/// @param {Real}    _height
function ds_grid_region_in_bounds(_dsGridId, _x, _y, _width, _height) {
    var _gridWidth = ds_grid_width(_dsGridId);
    var _gridHeight = ds_grid_height(_dsGridId);
    
    if(_width < 1 || _height < 1) {
        throw "checked region should have positive size";
    }
    
    if(_x < 0 || _x + _width >= _gridWidth) {
        return false;
    }

    if(_y < 0 || _y + _height >= _gridHeight) {
        return false;
    }

    return true;
}