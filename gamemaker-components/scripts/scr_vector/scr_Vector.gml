function vector2d_create_normal(_x, _y) {
	var length = sqrt(_x*_x + _y*_y);
	return {
		x: _x / length,
		y: _y / length
	};
}

function vector2d_normalize(v) {
	var length = sqrt(v.x*v.x + v.y*v.y);
	return {
		x: v.x / length,
		y: v.y / length
	};
}

function vector2d_inplace_normalize(v) {
	var length = sqrt(v.x*v.x + v.y*v.y);
	v.x /= length;
	v.y /= length;
	return v;
}

//Return the vector of v1 plus v2
function vector2d_add(v1, v2) {
	return {
		x: v1.x + v2.x,
		y: v1.y + v2.y
	};
}

//Add v2 to v1
function vector2d_inplace_add(v1, v2) {
	v1.x += v2.x;
	v1.y += v2.y;
	return v1;
}

//Subtract v2 from v1
function vector2d_subtract(v1, v2) {
	return {
		x: v1.x - v2.x,
		y: v1.y - v2.y
	}
}

//Subtract v2 from v1
function vector2d_inplace_subtract(v1, v2) {
	 v1.x -= v2.x;
	 v1.y -= v2.y;
	 return v1;
}

function vector2d_dot_product(v1, v2) {
	return (v1.x * v2.x) + (v1.y * v2.y);	
}

function vector2d_scale(v, s) {
	return {
		x: v.x * s,
		y: v.y * s
	}
}

function vector2d_inplace_scale(v, s) {
	v.x *= s;
	v.y *= s;
	return v;
}

//return the vector pointing from p1 to p2 normalized
function vector2d_direction_normalized(p1, p2) {
	var diff = vector2d_subtract(p2, p1);
	vector2d_inplace_normalize(diff);
	return diff;
}

function vector2d_rotate(_v1, _angleDegrees) {
	var rads = degtorad(_angleDegrees);
	var cs, sn;
	cs = cos(rads);
	sn = sin(rads);
	return {
		x: _v1.x * cs - _v1.y * sn,
		y: _v1.x * sn + _v1.y * cs
	}
}

function vector2d_inplace_rotate(_v1, _angleDegrees) {
	var rads = degtorad(_angleDegrees);
	var cs, sn;
	cs = cos(rads);
	sn = sin(rads);
	var xx = _v1.x * cs - _v1.y * sn;
	var yy = _v1.x * sn + _v1.y * cs;
	_v1.x = xx;
	_v1.y = yy;
	return _v1;
}

function vector2d_rotate_around(_v1, _p1, _angleDegrees) {
	var rads = degtorad(_angleDegrees);
	var cs, sn;
	cs = cos(rads);
	sn = sin(rads);
	_v1 = { x: _v1.x, y: _v1.y };
	vector2d_inplace_subtract(_v1, _p1);
	return {
		x: (_v1.x * cs - _v1.y * sn) + _p1.x,
		y: (_v1.x * sn + _v1.y * cs) + _p1.y
	}
}

//Warning: Must use normalized vectors
//Normal points up out of surface.
function vector2d_reflect(_v1, _n) {
	var dotProd = vector2d_dot_product(_v1, _n);
	var scaledN = vector2d_scale(_n, 2 * dotProd);
	return vector2d_subtract(_v1, scaledN);
}

//Warning: n must be normalized.
function vector2d_mirror(_v1, _n) {
	var projectedVector = vector2d_project(_v1, _n);
	var u = vector2d_subtract(projectedVector, _v1);
	return vector2d_add(_v1, vector2d_scale(u, 2));
}

//project v1 onto v2
function vector2d_project(_v1, _v2) {
	var d1 = vector2d_dot_product(_v1, _v2);
	var d2 = vector2d_dot_product(_v2, _v2);
	return vector2d_scale(_v2, d1 / d2);
}