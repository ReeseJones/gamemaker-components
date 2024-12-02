///@param {Asset.GMSprite} _sprite
///@param {Real} _subimg
///@param {Real} _x
///@param {Real} _y
///@param {Real} _xScale
///@param {Real} _yScale
///@param {Real} _rot
///@param {Constant.Color} _color
///@param {Real} _alpha
///@param {Real} _originX
///@param {Real} _originY
function draw_sprite_orig(_sprite, _subimg, _x, _y, _xScale, _yScale, _rot, _color, _alpha, _originX, _originY) {
    var _xOffset = (sprite_get_xoffset(_sprite) - _originX) * _xScale;
    var _yOffset = (sprite_get_yoffset(_sprite) - _originY) * _yScale;

    draw_sprite_ext(
        _sprite,
        _subimg,
        _x + lengthdir_x(_xOffset, _rot) + lengthdir_x(_yOffset, _rot - 90),
        _y + lengthdir_y(_xOffset, _rot) + lengthdir_y(_yOffset, _rot - 90),
        _xScale,
        _yScale,
        _rot,
        _color,
        _alpha
    );
}


///@param {Asset.GMSprite} _sprite
///@param {Real} _subimg
///@param {Real} _x
///@param {Real} _y
///@param {Real} _xScale
///@param {Real} _yScale
///@param {Real} _rot
///@param {Constant.Color} _color
///@param {Real} _alpha
///@param {Real} _originX
///@param {Real} _originY
///@param {Id.Instance} _inst
function draw_sprite_relative_orig(_sprite, _subimg, _x, _y, _xScale, _yScale, _rot, _color, _alpha, _originX, _originY, _inst) {
    static tempVec = new Vec2();

    tempVec.x = _x;
    tempVec.y = _y;
    transform_to_world_inplace(tempVec, _inst, _inst.image_angle);
    _rot = _inst.image_angle + _rot;

    draw_sprite_orig(_sprite, _subimg, tempVec.x, tempVec.y, _xScale, _yScale, _rot, _color, _alpha, _originX, _originY);
}