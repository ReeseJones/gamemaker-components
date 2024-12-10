function player_movement() {

    var _dt = game_get_speed(gamespeed_microseconds) / MICROSECONDS_PER_SECOND;
    var _movementSpeed = 200;
    var _vec = obj_game.vectorPool2d.getEntity();
    vector2d_zero(_vec);
    
    if (keyboard_check(ord("W")))
    {
        _vec.y -= 1;
    }
    
    if (keyboard_check(ord("S")))
    {
        _vec.y += 1;
    }
    
    if (keyboard_check(ord("A")))
    {
        _vec.x -= 1;
    }
    
    if (keyboard_check(ord("D")))
    {
        _vec.x += 1;
    }

    if(_vec.x != 0 || _vec.y != 0) {
        vector2d_inplace_normalize(_vec);
        vector2d_inplace_scale(_vec, _movementSpeed * _dt);
        vector2d_inplace_add(id, _vec);
        
        
    }
    
    
    obj_game.vectorPool2d.doneWithEntity(_vec);
}