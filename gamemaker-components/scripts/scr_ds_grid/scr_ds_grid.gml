/// @function        ds_grid_draw(_dsGridId)
/// @param {Id.DsGrid}    _dsGridId Id of the grid to draw
/// @param {Real}    _x Where to start drawing the grid from
/// @param {Real}    _y Where to start drawing the grid from.
/// @param {Real}    _cellSize size of the cells 
function ds_grid_draw(_dsGridId, _x, _y, _cellSize = 16) {
    var _gridWidth = ds_grid_width(_dsGridId);
    var _gridHeight = ds_grid_height(_dsGridId);


    var _gridLeft = _x;
    var _gridRight = _x + _cellSize * _gridWidth;
    var _gridTop = _y;
    var _gridBottom = _y + _cellSize * _gridHeight;

    for(var i = 0; i <= _gridHeight; i += 1) {
        draw_line(_gridLeft, _y + i * _cellSize, _gridRight, _y + i * _cellSize);
    }
    
    for(var i = 0; i <= _gridWidth; i += 1) {
        draw_line(_x + i * _cellSize, _gridTop, _x + i * _cellSize, _gridBottom);
    }
}

/// @function        ds_grid_get_pixel_width(_dsGridId)
/// @param {Id.DsGrid}    _dsGridId Id of the grid to draw
/// @param {Real}    _cellSize size of the cells
function ds_grid_get_pixel_width(_dsGridId, _cellSize) {
    return ds_grid_width(_dsGridId) * _cellSize;
}

/// @function        ds_grid_get_pixel_height(_dsGridId)
/// @param {Id.DsGrid}    _dsGridId Id of the grid to draw
/// @param {Real}    _cellSize size of the cells 
function ds_grid_get_pixel_height(_dsGridId, _cellSize) {
    return ds_grid_height(_dsGridId) * _cellSize;
}
