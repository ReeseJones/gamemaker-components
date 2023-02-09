function vector2d_create_normal(_x, _y) {
    var _length = sqrt(_x*_x + _y*_y);
    return {
        x: _x / _length,
        y: _y / _length
    };
}

function vector2d_normalize(_v) {
    var _length = sqrt(_v.x*_v.x + _v.y*_v.y);
    return {
        x: _v.x / _length,
        y: _v.y / _length
    };
}

function vector2d_inplace_normalize(_v) {
    var _length = sqrt(_v.x*_v.x + _v.y*_v.y);
    _v.x /= _length;
    _v.y /= _length;
    return _v;
}

//Return the vector of _v1 plus _v2
function vector2d_add(_v1, _v2) {
    return {
        x: _v1.x + _v2.x,
        y: _v1.y + _v2.y
    };
}

//Add _v2 to _v1
function vector2d_inplace_add(_v1, _v2) {
    _v1.x += _v2.x;
    _v1.y += _v2.y;
    return _v1;
}

//Subtract _v2 from _v1
function vector2d_subtract(_v1, _v2) {
    return {
        x: _v1.x - _v2.x,
        y: _v1.y - _v2.y
    }
}

//Subtract _v2 from _v1
function vector2d_inplace_subtract(_v1, _v2) {
     _v1.x -= _v2.x;
     _v1.y -= _v2.y;
     return _v1;
}

function vector2d_dot_product(_v1, _v2) {
    return (_v1.x * _v2.x) + (_v1.y * _v2.y);
}

function vector2d_scale(_v, _s) {
    return {
        x: _v.x * _s,
        y: _v.y * _s
    }
}

function vector2d_inplace_scale(_v, _s) {
    _v.x *= _s;
    _v.y *= _s;
    return _v;
}

//return the vector pointing from _p1 to _p2 normalized
function vector2d_direction_normalized(_p1, _p2) {
    var _diff = vector2d_subtract(_p2, _p1);
    vector2d_inplace_normalize(_diff);
    return _diff;
}

function vector2d_rotate(_v1, _angleDegrees) {
    var _rads = degtorad(_angleDegrees);
    var _cs, _sn;
    _cs = cos(_rads);
    _sn = sin(_rads);
    return {
        x: _v1.x * _cs - _v1.y * _sn,
        y: _v1.x * _sn + _v1.y * _cs
    }
}

function vector2d_inplace_rotate(_v1, _angleDegrees) {
    var _rads = degtorad(_angleDegrees);
    var _cs, _sn;
    _cs = cos(_rads);
    _sn = sin(_rads);
    var _xx = _v1.x * _cs - _v1.y * _sn;
    var _yy = _v1.x * _sn + _v1.y * _cs;
    _v1.x = _xx;
    _v1.y = _yy;
    return _v1;
}

function vector2d_rotate_around(_v1, _p1, _angleDegrees) {
    var _rads = degtorad(_angleDegrees);
    var _cs, _sn;
    _cs = cos(_rads);
    _sn = sin(_rads);
    _v1 = { x: _v1.x, y: _v1.y };
    vector2d_inplace_subtract(_v1, _p1);
    return {
        x: (_v1.x * _cs - _v1.y * _sn) + _p1.x,
        y: (_v1.x * _sn + _v1.y * _cs) + _p1.y
    }
}

//Warning: Must use normalized vectors
//Normal points up out of surface.
function vector2d_reflect(_v1, _n) {
    var _dotProd = vector2d_dot_product(_v1, _n);
    var _scaledN = vector2d_scale(_n, 2 * _dotProd);
    return vector2d_subtract(_v1, _scaledN);
}

//Warning: n must be normalized.
function vector2d_mirror(_v1, _n) {
    var _projectedVector = vector2d_project(_v1, _n);
    var _u = vector2d_subtract(_projectedVector, _v1);
    return vector2d_add(_v1, vector2d_scale(_u, 2));
}

//project _v1 onto _v2
function vector2d_project(_v1, _v2) {
    var _d1 = vector2d_dot_product(_v1, _v2);
    var _d2 = vector2d_dot_product(_v2, _v2);
    return vector2d_scale(_v2, _d1 / _d2);
}