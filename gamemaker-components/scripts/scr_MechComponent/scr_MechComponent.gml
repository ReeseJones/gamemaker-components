///@function MechComponent(_sockets)
///@param {real} _width The width measured in cells
///@param {real} _height The height measured in cells
///@param {Array<Struct.MechSocket>} _sockets The array of sockets this component has.
function MechComponent(_width, _height, _sockets = []) constructor {
    static staticComponentId = 0;
    id = $"cId:{++staticComponentId}";
    dataId = undefined;
    name = "";
    sockets = _sockets;
    position = new Vec2();
    width = _width;
    height = _height;
    spriteIndex = choose(spr_mech_doodad01, spr_mech_doodad02, spr_mech_doodad03, spr_mech_doodad04,spr_mech_doodad05, spr_mech_doodad06);
    orientation = 0;
    flipVertical = false;
    flipHorizontal = false;
}

///@function mech_component_draw(_mechSystem, _component)
///@param {Struct.MechSystem} _mechSystem 
///@param {Struct.MechComponent} _component
function mech_component_draw(_mechSystem, _component) {
    
    var _x = mech_system_grid_cell_position_x(_mechSystem, _component.position.x);
    var _y = mech_system_grid_cell_position_y(_mechSystem, _component.position.y);

    var _xOffset = _component.width * MECH_CELL_SIZE / 2;
    var _yOffset = _component.height * MECH_CELL_SIZE / 2;

    var _xScale = (MECH_CELL_SIZE * _component.width) / sprite_get_width(_component.spriteIndex);
    var _yScale = (MECH_CELL_SIZE * _component.height) / sprite_get_height(_component.spriteIndex);

    draw_sprite_ext(
        _component.spriteIndex,
        0, 
        _x + _xOffset, 
        _y + _yOffset, 
        _xScale, 
        _yScale,
        _component.orientation, 
        c_white, 
        1
    );

    var _socketCount = array_length( _component.sockets );
    for(var i = 0; i < _socketCount; i += 1) {
        var _socket = _component.sockets[i];
        mech_socket_draw(_mechSystem, _component, _socket);
    }
}