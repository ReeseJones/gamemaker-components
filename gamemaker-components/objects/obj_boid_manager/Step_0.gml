/// @description Insert description here
// You can write your code in this editor
for( var i = 0; i < boidCount; i += 1) {
    var _boid = boidList[i];

    boid_calculate_velocity(steeringProperties, _boid, boidList);

    _boid.position.x += _boid.velocity.x;
    _boid.position.y += _boid.velocity.y;
    
    if(_boid.position.x > bounds.right) {
        _boid.position.x = bounds.left;
    } else if (_boid.position.x < bounds.left) {
        _boid.position.x = bounds.right;
    }

    if(_boid.position.y > bounds.bottom) {
        _boid.position.y = bounds.top;
    } else if (_boid.position.y < bounds.top) {
        _boid.position.y = bounds.bottom;
    }
}