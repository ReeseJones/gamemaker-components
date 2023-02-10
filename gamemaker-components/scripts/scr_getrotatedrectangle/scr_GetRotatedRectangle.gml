tag_script(rect_get_rotated, [TAG_MATH, TAG_GEOMETRY])
function rect_get_rotated(_x, _y, _halfWidth, _halfHeight, _angleDeg) {
    var _rads = degtorad(-_angleDeg);
    var c = cos(_rads);
    var s = sin(_rads);
    
    var _tlx = -_halfWidth * c - (-_halfHeight * s);
    var _tly = -_halfWidth * s + (-_halfHeight * c);
    
    var _brx =  _halfWidth * c - _halfHeight * s;
    var _bry =  _halfWidth * s + _halfHeight * c;

    
    return {
        tl: {x: _x + _tlx, y: _y + _tly },
        br: {x: _x + _brx, y: _y + _bry }
    };
}