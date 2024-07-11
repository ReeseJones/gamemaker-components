#macro MECH_CELL_SIZE 16

///@function MechSystem(_gridWidth, _gridHeight, _components)
///@param {real} _gridWidth The number of horizontal cells in the grid.
///@param {real} _gridHeight The number of vertical cells in the grid.
///@param {Array<Struct.MechComponent>} _components The components installed in this mech
function MechSystem(_gridWidth, _gridHeight, _components = []) constructor {
    components = _components;
    mechComponentGrid = new EntityCollisionGrid(_gridWidth, _gridWidth);
    // Map of component id to Struct.MechComponent
    componentMap = {};
    // Map of component id to component position
    componentPositionMap = {};
    
    
    static dispose = function () {
        mechComponentGrid.dispose();
        delete mechComponentGrid;
        delete componentMap;
        delete componentPositionMap
    }
}

///@function mech_system_draw(_mechSystem)
///@param {Struct.MechSystem} _mechSystem The number of horizontal cells in the grid.
function mech_system_draw(_mechSystem) {

    var _x = _mechSystem.position.x;
    var _y = _mechSystem.position.y;

    var _gridPixelWidth = _mechSystem.gridWidth * MECH_CELL_SIZE;
    var _gridPixelHeight = _mechSystem.gridHeight * MECH_CELL_SIZE;
    var _left = _x - _gridPixelWidth / 2;
    var _top = _y - _gridPixelHeight / 2;

    if(_mechSystem.drawGrid) {
        draw_set_alpha(0.6);
        draw_grid(_left, _top, MECH_CELL_SIZE, MECH_CELL_SIZE, _mechSystem.gridWidth, _mechSystem.gridHeight);
        draw_set_alpha(1);
    }
}

///@function mech_system_grid_cell_position_x(_mechSystem, _x)
///@param {Struct.MechSystem} _mechSystem The number of horizontal cells in the grid.
///@param {Real} _x cell position
function mech_system_grid_cell_position_x(_mechSystem, _x) {
    var _gridPixelWidth = _mechSystem.gridWidth * MECH_CELL_SIZE;
    var _left = _mechSystem.position.x - _gridPixelWidth / 2;
    return _left + _x * MECH_CELL_SIZE;
}

///@function mech_system_grid_cell_position_y(_mechSystem, _y)
///@param {Struct.MechSystem} _mechSystem The number of horizontal cells in the grid.
///@param {Real} _y cell position
function mech_system_grid_cell_position_y(_mechSystem, _y) {
    var _gridPixelHeight = _mechSystem.gridHeight * MECH_CELL_SIZE;
    var _top = _mechSystem.position.y - _gridPixelHeight / 2;
    return _top + _y * MECH_CELL_SIZE;
}