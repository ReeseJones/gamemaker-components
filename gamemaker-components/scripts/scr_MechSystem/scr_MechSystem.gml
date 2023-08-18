#macro MECH_CELL_SIZE 16

///@function MechSystem(_gridWidth, _gridHeight, _components)
///@param {real} _gridWidth The number of horizontal cells in the grid.
///@param {real} _gridHeight The number of vertical cells in the grid.
///@param {Array<Struct.MechComponent>} _components The components installed in this mech
function MechSystem(_gridWidth, _gridHeight, _components = []) constructor {
	
	position = new Vec2();
    components = _components;
    gridWidth = _gridWidth;
    gridHeight = _gridHeight;
    drawGrid = true;

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
        draw_grid(_left, _top, MECH_CELL_SIZE, MECH_CELL_SIZE, _mechSystem.gridWidth, _mechSystem.gridHeight);
    }
    
    var _componentCount = array_length( _mechSystem.components );
    for(var i = 0; i < _componentCount; i += 1) {
		var _component = _mechSystem.components[i];
        mech_component_draw(_mechSystem, _component);
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