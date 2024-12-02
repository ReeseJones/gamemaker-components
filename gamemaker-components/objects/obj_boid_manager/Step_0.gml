//Insert boids into spatial grid.
spatialGrid.clearAll();
for( var i = 0; i < boidCount; i += 1) {
    var _boid = boidList[i];
    var _pos = _boid.position;
    spatialGrid.insert(i, _pos.y - 10, _pos.x - 10, _pos.y + 10, _pos.x + 10);
}

for( var i = 0; i < boidCount; i += 1) {
    var _boid = boidList[i];
    var _pos = _boid.position;
    array_resize(tempBoidIds, 0);
    var _vr = steeringProperties.viewRadius;
    spatialGrid.getEntitiesNearArea(_pos.y - _vr, _pos.x - _vr, _pos.y + _vr, _pos.x + _vr, tempBoidIds);
    boid_calculate_velocity(steeringProperties, _boid, tempBoidIds, boidList);

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