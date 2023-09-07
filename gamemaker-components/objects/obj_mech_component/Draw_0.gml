draw_self();

var _halfWidth = sprite_width / 2;
var _halfHeight = sprite_height / 2;

if(mouseIsOver) {
    draw_set_color(c_white);
    draw_set_alpha(0.3);
    draw_roundrect(
        x -_halfWidth - 4,
        y - _halfHeight - 4,
        x + _halfWidth + 4,
        y + _halfHeight + 4,
        false
    );
}

if(controlMode == MECH_CONTROL_MODE.EDIT) {
    //var _mechSystem = mechParent.mechSystem;

    draw_set_alpha(0.3);
    draw_set_color(c_lime);
    draw_grid(x - _halfWidth, y - _halfHeight, MECH_CELL_SIZE, MECH_CELL_SIZE, component.width, component.height);
    
    var _socketCount = array_length(component.sockets);
    
    for(var i = 0; i < _socketCount; i += 1) {
        var _socket = component.sockets[i];
        mech_socket_draw(mechParent.mechSystem, component, _socket);
    }
}

draw_set_alpha(1);