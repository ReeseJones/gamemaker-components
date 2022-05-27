function RectGetRotated(_x, _y, _halfWidth, _halfHeight, _angleDeg) {
	var rads = degtorad(-_angleDeg);
	var c = cos(rads);
    var s = sin(rads);
    
	var tlx = -_halfWidth * c - (-_halfHeight * s);
    var tly = -_halfWidth * s + (-_halfHeight * c);
	
    var brx =  _halfWidth * c - _halfHeight * s;
    var bry =  _halfWidth * s + _halfHeight * c;

	
	return {
		tl: {x: _x + tlx, y: _y + tly },
		br: {x: _x + brx, y: _y + bry }
	};    
}