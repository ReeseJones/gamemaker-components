
global.vectors = {
    seperationVec: new Vec2(),
    alignmentVec: new Vec2(),
    cohesionVec: new Vec2(),
    boidDirectionDiff: new Vec2(),
    tempVec: new Vec2(),
    accelerationVec: new Vec2(),
    averagePosition: new Vec2()
};

///@param {Struct.BoidSteeringProperties} _steeringProperties
///@param {Struct.Boid} _boid
///@param {Array<real} _otherBoidsIds
///@param {Array<Struct.Boid>} _otherBoids
function boid_calculate_velocity(_steeringProperties, _boid, _otherBoidsIds, _otherBoids) {
    var _spererationVec = global.vectors.seperationVec;
    var _alignmentVec = global.vectors.alignmentVec;
    var _cohesionVec = global.vectors.cohesionVec;
    var _boidDirectionDiff = global.vectors.boidDirectionDiff;
    var _tempVec = global.vectors.tempVec;
    var _accelerationVec = global.vectors.accelerationVec;
    var _averagePosition = global.vectors.averagePosition;

    vector2d_zero(_spererationVec);
    vector2d_zero(_accelerationVec);
    vector2d_zero(_alignmentVec);
    vector2d_zero(_averagePosition);

    var _otherBoidCount = array_length(_otherBoidsIds);
    var _boidsInSeperationRange = 0;
    var _boidsInAlignmentRange = 0;
    var _boidsInCohesionRange = 0;
    for(var i = 0; i < _otherBoidCount; i += 1) {
        var _otherBoid = _otherBoids[_otherBoidsIds[i]];
        _boidDirectionDiff.x = _boid.position.x - _otherBoid.position.x;
        _boidDirectionDiff.y = _boid.position.y - _otherBoid.position.y;

        var _distance = vector2d_length(_boidDirectionDiff);
        if(_distance > _steeringProperties.viewRadius) {
            continue;
        }

        //Sep
        if(_distance < _steeringProperties.seperationDistance && _distance > 0) {
            _boidsInSeperationRange += 1;

            // Temp vec will have normalized difference vector
            vector2d_copy_to(_boidDirectionDiff, _tempVec);
            vector2d_inplace_normalize(_tempVec);
            vector2d_inplace_scale(_tempVec, 1 / _distance); //scale normal diff by distance
            vector2d_inplace_add(_spererationVec, _tempVec);
        }
        
        
        //align
        if(_distance < _steeringProperties.alignmentDistance && _distance > 0) {
            _boidsInAlignmentRange += 1;
            vector2d_inplace_add(_alignmentVec, _otherBoid.velocity);
        }

        //cohesion
        if(_distance < _steeringProperties.alignmentDistance && _distance > 0) {
            _boidsInCohesionRange += 1;
            vector2d_inplace_add(_averagePosition, _otherBoid.position);
        }
    }

    // Seperation: Average seperation forces
    if (_boidsInSeperationRange > 0) {
        vector2d_inplace_scale(_spererationVec, 1 / _boidsInSeperationRange);
    }
    // Speration steering -> steering = desired - velocity
    if (_spererationVec.x != 0 || _spererationVec.y != 0) {
        vector2d_length_set(_spererationVec, _steeringProperties.maxSpeed);
        vector2d_inplace_subtract(_spererationVec, _boid.velocity);
        vector2d_length_limit(_spererationVec, _steeringProperties.maxForce);
    }
    // scale seperation vec by multipler
    vector2d_inplace_scale(_spererationVec, _steeringProperties.weightSeparation);
    vector2d_inplace_add(_accelerationVec, _spererationVec);
 
    //Alignment
    if(_boidsInAlignmentRange > 0) {
        vector2d_inplace_scale(_alignmentVec, 1 / _boidsInAlignmentRange);
        vector2d_length_set(_alignmentVec, _steeringProperties.maxSpeed);
        vector2d_inplace_subtract(_alignmentVec, _boid.velocity);
        vector2d_length_limit(_alignmentVec, _steeringProperties.maxForce);
        
        vector2d_inplace_scale(_alignmentVec, _steeringProperties.weightAlignment);
        vector2d_inplace_add(_accelerationVec, _alignmentVec);
    }
 
    //cohesion
    if(_boidsInCohesionRange > 0) {
        vector2d_inplace_scale(_averagePosition, 1 / _boidsInCohesionRange);
        vector2d_inplace_subtract(_averagePosition, _boid.position);
        vector2d_length_set(_averagePosition, _steeringProperties.maxSpeed);
        vector2d_inplace_subtract(_averagePosition, _boid.velocity);
        vector2d_length_limit(_averagePosition, _steeringProperties.maxForce);
        vector2d_inplace_add(_accelerationVec, _averagePosition);
    }

    // Update Velocity
    vector2d_inplace_add(_boid.velocity, _accelerationVec);
    vector2d_length_limit(_boid.velocity, _steeringProperties.maxSpeed);
}
