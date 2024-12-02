///@param {Struct.Vec2} _point A local space point
///@param {Struct.Vec2} _origin world position to move point relative to
///@param {real} _originAngle Angle in degrees of new world origin
///@return {Struct.Vec2}
function transform_to_world(_point, _origin, _originAngle) {
    var _outVec = new Vec2(_point.x, _point.y);

    vector2d_inplace_rotate(_outVec, -_originAngle);
    vector2d_inplace_add(_outVec, _origin);

    return _outVec;
}

///@param {Struct.Vec2} _point A local space point
///@param {Struct.Vec2} _origin world position to move point relative to
///@param {real} _originAngle Angle in degrees of new world origin
function transform_to_world_inplace(_point, _origin, _originAngle) {
    vector2d_inplace_rotate(_point, -_originAngle);
    vector2d_inplace_add(_point, _origin);
    return _point;
}