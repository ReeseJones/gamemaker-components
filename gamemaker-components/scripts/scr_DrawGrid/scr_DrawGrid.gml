/// @function        draw_grid(_x, y_, _cellWidth, _cellHeight)
/// @param {Real}    _x Where to start drawing the grid from
/// @param {Real}    _y Where to start drawing the grid from.
/// @param {Real}    _cellWidth size of the cells
/// @param {Real}    _cellHeight size of the cells
/// @param {Real}    _horizontalCells count of the cells
/// @param {Real}    _verticalCells count of the cells
function draw_grid(_x, _y, _cellWidth, _cellHeight, _gridWidth, _gridHeight) {
    var _gridLeft = _x;
    var _gridRight = _x + _cellWidth * _gridWidth;
    var _gridTop = _y;
    var _gridBottom = _y + _cellHeight * _gridHeight;

    for(var i = 0; i <= _gridHeight; i += 1) {
        draw_line(_gridLeft, _y + i * _cellHeight, _gridRight, _y + i * _cellHeight);
    }
    
    for(var i = 0; i <= _gridWidth; i += 1) {
        draw_line(_x + i * _cellWidth, _gridTop, _x + i * _cellWidth, _gridBottom);
    }
}

