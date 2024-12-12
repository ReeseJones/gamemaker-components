function player_movement() {
    static tempVec = new Vec2();
    var _dt = game_get_speed(gamespeed_microseconds) / MICROSECONDS_PER_SECOND;
    var _movementSpeed = 200;
    var _x = 0;
    var _y = 0;
    
    if (keyboard_check(ord("W")))
    {
        _y -= 1;
    }
    
    if (keyboard_check(ord("S")))
    {
        _y += 1;
    }
    
    if (keyboard_check(ord("A")))
    {
        _x -= 1;
    }
    
    if (keyboard_check(ord("D")))
    {
        _x += 1;
    }

    if(_x != 0 || _y != 0) {
        tempVec.x = _x;
        tempVec.y = _y;
        vector2d_inplace_normalize(tempVec);
        vector2d_inplace_scale(tempVec, _movementSpeed * _dt);
        vector2d_inplace_add(id, tempVec);
    }
}