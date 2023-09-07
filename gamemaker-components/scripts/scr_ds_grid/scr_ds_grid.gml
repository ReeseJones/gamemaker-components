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
    
    if(_x < 0 || _x + _width - 1 >= _gridWidth) {
        return false;
    }

    if(_y < 0 || _y + _height - 1 >= _gridHeight) {
        return false;
    }

    return true;
}

function ds_grid_draw_debug(_gridId, _x, _y) {
    var _w       = ds_grid_width(_gridId);
    var _h       = ds_grid_height(_gridId);

    // Modify these two variables for width of column and height of row.
    var _wbuffer    = 25;
    var _hbuffer    = 25;

    for (var i = 0; i < _w; i += 1){
        for (var j = 0; j < _h; j += 1){
            var _value = ds_grid_get(_gridId, i, j);
            draw_point_color(_x + i * _wbuffer, _y + j * _hbuffer, c_red);
            draw_rectangle(
                _x + i * _wbuffer,
                _y + j * _hbuffer,
                _x + i * _wbuffer + _wbuffer,
                _y + j * _hbuffer + _hbuffer,
                true);
            draw_text(_x + i * _wbuffer, _y + j * _hbuffer, string(_value));
        };
    };

}