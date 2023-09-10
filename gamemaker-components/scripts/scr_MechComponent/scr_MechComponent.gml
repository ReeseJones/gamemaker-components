struct_serialize_as(MechComponent, nameof(MechComponent));
///@function MechComponent(_sockets)
///@param {Struct.MechComponentData} _componentData
function MechComponent(_componentData) constructor {
    static staticComponentId = 0;
    // A unique runtime id
    id = $"cId:{++staticComponentId}";
    componentData =_componentData;
    placement = new MechComponentPlacementOptions();
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
