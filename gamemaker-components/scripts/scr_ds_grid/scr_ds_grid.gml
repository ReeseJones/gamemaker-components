/// @function        ds_grid_draw(_dsGridId)
/// @param {Id.DsGrid}    _dsGridId Id of the grid to draw
/// @param {Real}    _x Where to start drawing the grid from
/// @param {Real}    _y Where to start drawing the grid from.
/// @param {Real}    _cellSize size of the cells 
function ds_grid_draw(_dsGridId, _x, _y, _cellSize = 16) {
    var _gridWidth = ds_grid_width(_dsGridId);
    var _gridHeight = ds_grid_height(_dsGridId);
    
    draw_grid(_x, _y, _cellSize, _cellSize, _gridWidth, _gridHeight);
}