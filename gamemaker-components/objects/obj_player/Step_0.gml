

tempVec.x = 0;
tempVec.y = 0;


if ( keyboard_check(ord("W")) ) {
    tempVec.y -= 1;	
}

if ( keyboard_check(ord("S")) ) {
    tempVec.y += 1;
}

if ( keyboard_check(ord("A")) ) {
    tempVec.x -= 1;
}

if ( keyboard_check(ord("D")) ) {
    tempVec.x += 1;
}

if (tempVec.x != 0 || tempVec.y != 0) {
    vector2d_inplace_normalize(tempVec);
    vector2d_inplace_scale(tempVec, acceleration);
    vector2d_inplace_add(velocity, tempVec);
    
    var _length = vector2d_length(velocity);
    if(_length > topSpeed) {
        vector2d_inplace_normalize(velocity);
        vector2d_inplace_scale(velocity, topSpeed);
    }
} else {

    var _length = vector2d_length(velocity);

    if(_length > deceleration) {
        _length -= deceleration;
        vector2d_inplace_normalize(velocity);
        vector2d_inplace_scale(velocity, _length);
    } else {
        velocity.x = 0;
        velocity.y = 0;
    }
}

var _velLength = vector2d_length(velocity);

if(_velLength > 0) {
    var _collisions = move_and_collide(velocity.x, velocity.y, obj_solid);
    //image_angle = point_direction(0, 0, velocity.x, velocity.y);

    if(array_length(_collisions) > 0 ) {
        //show_debug_message("colliding with things");
    }
}

//show_debug_message(velocity);

