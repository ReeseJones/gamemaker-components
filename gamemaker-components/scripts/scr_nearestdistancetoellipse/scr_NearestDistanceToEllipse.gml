function ellipe_tan_dot(_rx, _ry, px, py, _theta) {
    /*	
		Dot product of the equation of the line formed by the point
		with another point on the ellipse's boundary and the tangent of the ellipse
		at that point on the boundary.
    */
    return ((sqr(_rx) - sqr(_ry)) * cos(_theta) * sin(_theta) -
            px * _rx * sin(_theta) + py * _ry * cos(_theta));
}


function ellipe_tan_dot_derivative(_rx, _ry, px, py, _theta) {
    /*
		The derivative of ellipe_tan_dot.
    */
    return ((sqr(_rx) - sqr(_ry)) * (sqr(cos(_theta)) - sqr(sin(_theta))) -
            px * _rx * cos(_theta) - py * _ry * sin(_theta));
}


/*
	Given a point (_x, _y), and an ellipse with major - minor axis (_rx, _ry),
	its center at (_x0, _y0), and with a counter clockwise rotation of
	`_angle` degrees, will return the distance between the ellipse and the
	closest point on the ellipses boundary.
*/
function nearest_point_on_ellipse(_x, _y, _rx, _ry, _x0 = 0, _y0 = 0, _angle = 0, _error = 0.00001) {
    
    _x -= _x0;
    _y -= _y0;
	
    if (_angle) {
        // rotate the points onto an ellipse whose _rx, and _ry lay on the _x, _y
        // axis
        _angle = -pi / 180 * _angle;
        var _xRot = _x * cos(_angle) - _y * sin(_angle);
		var _yRot = _x * sin(_angle) + _y * cos(_angle);
		_x = _xRot;
		_y = _yRot;
	}

    var _theta = arctan2(_rx * _y, _ry * _x);
	var cancel = 0;
    while( abs(ellipe_tan_dot(_rx, _ry, _x, _y, _theta)) > _error ) {
        _theta -= ellipe_tan_dot(_rx, _ry, _x, _y, _theta) / ellipe_tan_dot_derivative(_rx, _ry, _x, _y, _theta);
		if(++cancel > 30) {
			show_debug_message("lol");
			break;
		}
	}

    var px = _rx * cos(_theta);
	var py = _ry * sin(_theta);
	
	if(_angle) {
		var xRot2 = px * cos(-_angle) - py * sin(-_angle);
		var yRot2 = px * sin(-_angle) + py * cos(-_angle);
		
		px = xRot2;
		py = yRot2;
	}
	
	px += _x0;
	py += _y0;	
	
	return {
		x: px,
		y: py
	};
}