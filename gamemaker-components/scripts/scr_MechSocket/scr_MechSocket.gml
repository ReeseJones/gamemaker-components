enum CONNECTION_DIRECTION {
    TOP,
    LEFT,
    BOTTOM,
    RIGHT,
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

    if(array_length(_connections) != 4) {
        throw "Connection array should have exact length of 4";
    }

    //TODO: make it so you can turn off connections by direction.
    disabledConnections = [CONNECTION_DIRECTION.NONE];
    connections = _connections;
}

///@function mech_socket_draw(_socket)
///@param {Struct.MechSocket} _socket Component to which this socket belongs.
function mech_socket_draw(_socket) {

}