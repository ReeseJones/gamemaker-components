//Specific indicies into array of directions
enum CONNECTION_DIRECTION {
    RIGHT = 0,
    TOP = 1,
    LEFT = 2,
    BOTTOM = 3,
    COUNT = 4,
    NONE,
}

///@function MechSocket(_xPos, _yPos, _connections)
///@description A socket is one cell of a mech component. A socket will connect to any other sockets that touch it from other components.
///@param {Real} _xPos
///@param {Real} _yPos
///@param {Array<Struct.MechComponent>} _connections Component to which this socket belongs.
function MechSocket(_xPos = 0, _yPos = 0, _connections = array_create(4, undefined)) constructor {
    //Position in component grid
    position = new Vec2(_xPos, _yPos);

    if (array_length(_connections) != CONNECTION_DIRECTION.COUNT) {
        throw $"Connection array should have exact length of {CONNECTION_DIRECTION.COUNT}";
    }

    //TODO: make it so you can turn off connections by direction.
    disabledConnections = [CONNECTION_DIRECTION.NONE];
    connections = _connections;
}

///@function mech_socket_draw(_socket)
///@param {Struct.MechSystem} _mechSystem
///@param {Struct.MechComponent} _mechComponent
///@param {Struct.MechSocket} _socket
function mech_socket_draw(_mechSystem, _mechComponent, _socket) {
    var _xPos = _mechComponent.position.x + _socket.position.x;
    var _yPos = _mechComponent.position.y + _socket.position.y;

    var _x = mech_system_grid_cell_position_x(_mechSystem, _xPos);
    var _y = mech_system_grid_cell_position_y(_mechSystem, _yPos);

    draw_set_color(c_aqua);
    draw_rectangle(_x + 4, _y + 4, _x + 13, _y + 13, true);

    var _xCenter = _x + MECH_CELL_SIZE / 2;
    var _yCenter = _y + MECH_CELL_SIZE / 2;
    var _blipLength = 16;

    draw_set_color(c_orange);
    var _connectionCount = array_length(_socket.connections);
    for (var i = 0; i < _connectionCount; i += 1 ) {
        if( _socket.connections[i] != undefined ) {
            var _xEnd = _xCenter + lengthdir_x(_blipLength, i * 90);
            var _yEnd = _yCenter + lengthdir_y(_blipLength, i * 90);

            draw_arrow(_xCenter, _yCenter, _xEnd, _yEnd, 9);
        }
    }
}