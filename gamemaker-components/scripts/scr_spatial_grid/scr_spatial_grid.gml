function SpatialGrid(_width, _height, _horizontalCells, _verticalCells) constructor {
    static resizeGrid = function(_width, _height, _horizontalCells, _verticalCells) {
        width = _width;
        height = _height;
        horizontalCells = _horizontalCells;
        verticalCells = _verticalCells;
        cellWidth = width / horizontalCells;
        cellHeight = height / verticalCells;
        cells = array_create_ext(horizontalCells * verticalCells, array_create_empty);
    }

    ///@description Insert an entityId into the spatial grid using the world coordinates of a bounding box.
    ///@param {Real} _entityId
    ///@param {Real} _top
    ///@param {Real} _left
    ///@param {Real} _bottom
    ///@param {Real} _right
    static insert = function(_entityId, _top, _left, _bottom, _right) {
        //var _minX = min(_left, _right);
        //var _maxX = max(_left, _right);
        //var _minY = min(_top, _bottom);
        //var _maxY = max(_top, _bottom);

        /*
        var _leftX = floor(_left / cellWidth);
        var _rightX = floor( _right / cellWidth);
        var _topY = floor(_top / cellHeight);
        var _bottomY = floor( _bottom / cellHeight);
        */

        var _x = floor((_left + _right) / 2 / cellWidth);
        var _y = floor((_top + _bottom) / 2 / cellWidth);

        var _maxWidthIndex = horizontalCells - 1;
        var _maxHeightIndex = verticalCells - 1;

/*
        if( rectangle_in_rectangle(0, 0, _maxWidthIndex, _maxHeightIndex, _leftX, _topY, _rightX, _bottomY) == 0) {
            // rectanlge_in_rectangle == 0 means no collision. so nothing ot insert.
            return;
        }
*/

        if(!point_in_rectangle(_x, _y, 0, 0, _maxWidthIndex, _maxHeightIndex)) {
            // rectanlge_in_rectangle == 0 means no collision. so nothing ot insert.
            return;
        }

        /*
        _rightX = min(_rightX, _maxWidthIndex);
        _bottomY = min(_bottomY, _maxHeightIndex);
        for(var _y = max(_topY, 0); _y <= _bottomY; _y += 1) {
            for( var _x = max(_leftX, 0); _x <= _rightX; _x += 1) {
                var _index = (_y * horizontalCells) + _x;
                var _cellArray = cells[_index];
                array_insert_sorted_unique(_cellArray, _entityId);
            }
        }
        */
        var _index = (_y * horizontalCells) + _x;
        var _cellArray = cells[_index];
        array_insert_sorted_unique(_cellArray, _entityId);
    }

    static clearAll = function() {
        var _totalCells = array_length(cells);
        for (var _i = 0; _i < _totalCells; _i += 1) {
            array_resize(cells[_i], 0);
        }
    }

    static getEntitiesNearArea = function(_top, _left, _bottom, _right, _outputArray = []) { 
        var _leftX = floor(_left / cellWidth);
        var _rightX = floor( _right / cellWidth);
        var _topY = floor(_top / cellHeight);
        var _bottomY = floor( _bottom / cellHeight);
        var _maxWidthIndex = horizontalCells - 1;
        var _maxHeightIndex = verticalCells - 1;

        if( rectangle_in_rectangle(0, 0, _maxWidthIndex, _maxHeightIndex, _leftX, _topY, _rightX, _bottomY) == 0) {
            // rectanlge_in_rectangle == 0 means no collision. so nothing ot insert.
            return _outputArray;
        }

        _rightX = min(_rightX, _maxWidthIndex);
        _bottomY = min(_bottomY, _maxHeightIndex);
        for(var _y = max(_topY, 0); _y <= _bottomY; _y += 1) {
            for( var _x = max(_leftX, 0); _x <= _rightX; _x += 1) {
                var _index = (_y * horizontalCells) + _x;
                var _cellArray = cells[_index];
                var _entityCount = array_length(_cellArray);

                for(var _j = 0; _j < _entityCount; _j += 1) {
                    var _entityId = _cellArray[_j];
                    //if(!array_contains(_outputArray, _entityId)) {
                        array_push(_outputArray, _entityId);
                    //}
                }
            }
        }

        return _outputArray;
    }

    resizeGrid(_width, _height, _horizontalCells, _verticalCells);
}