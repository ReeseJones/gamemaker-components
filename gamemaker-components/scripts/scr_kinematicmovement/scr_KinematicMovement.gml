function KinematicMovement(_instance) : Component(_instance) constructor {
    // Feather disable GM2017
    direction = { x: 1, y: 0 };
    speed = 0;
    mass = 1;
    debugCollisionsPoints = [];
    debugReflectionVector = [];
    // Feather restore GM2017
}

function KinematicMovementSystem(_world) : ComponentSystem(_world) constructor {

     // Feather disable GM2017
    entityCollisionList = undefined;
     // Feather restore GM2017

    static systemStart = function system_start() {
        entityCollisionList = ds_list_create();
    }
    
    static systemCleanup = function system_cleanup() {
        ds_list_destroy(entityCollisionList);
    }
    
    static setSpeed = function set_speed(_entityId, _speed) {
        var _inst = entity.getRef(_entityId);
        var _km = _inst.components.kinematicMovement;
        _km.speed = _speed;
    }
    
    static setDirectionVector = function set_direction_vector(_entityId, _x, _y) {
        var _inst = entity.getRef(_entityId);
        var _km = _inst.components.kinematicMovement;
        var _length = sqrt(_x*_x + _y*_y);
        _km.direction.x = _x / _length;
        _km.direction.y = _y / _length;
    }

    static setDirectionAngle = function set_direction_angle(_entityId, _angleDegrees) {
        var _inst = entity.getRef(_entityId);
        var _km = _inst.components.kinematicMovement;
        var _angleInRads = degtorad(_angleDegrees);
        _km.direction.x = cos(_angleInRads);
        //inverting sign because postive y is down in game maker
        _km.direction.y = -sin(_angleInRads);
    }

    static onCreate = function on_create(_km) {
        static collisionList = ds_list_create();
        
        with(_km.instance) {
            show_debug_message("Testing start collisions");
            ds_list_clear(collisionList);
            var _num = instance_place_list(x, y, obj_solid, collisionList, false);

            for (var i = 0; i < _num; ++i)
            {
                show_debug_message("Removed starting instance");
                instance_destroy(collisionList[| i]);
            }
        }
    }

    static step = function step(_km, _dt) {

        array_resize(_km.debugCollisionsPoints, 0 );
        array_resize(_km.debugReflectionVector, 0 );
        
        var _tempEntityList = entityCollisionList;
        var _inst = _km.instance;
        var _entityComp = _inst.components.entity;
        if(_km.speed == 0) {
            //static objects do not need to be updated.
            return;
        }
        if(_km.direction.x == 0 && _km.direction.y == 0) {
            //objects with no direction cannot move
            return;
        }

        var _xOffset = _km.direction.x * _km.speed;
        var _yOffset = _km.direction.y * _km.speed;
        var _iterations = min(8, round(_km.speed));
        var _currentIteration = 0;
        var _xIterationAmount = _xOffset / _iterations;
        var _yIterationAmount = _yOffset / _iterations;
        var _foilMoveAccumulator = {x: 0, y: 0};
        
        var _entityId = _km.getEntityId();
        
        //TODO: TEMP CODE: Point towards mouse
        var _dir = point_direction(_entityComp.x, _entityComp.y, mouse_x, mouse_y);
        setDirectionAngle(_entityId, _dir);

        with(_inst) {
            for(_currentIteration = 0; _currentIteration < _iterations; _currentIteration += 1) {
                ds_list_clear(_tempEntityList);
                var _collisionCount = instance_place_list(_entityComp.x + _xIterationAmount, _entityComp.y + _yIterationAmount, obj_solid, _tempEntityList, true);
                
                if(_collisionCount == 0) {
                    _entityComp.x += _xIterationAmount;
                    _entityComp.y += _yIterationAmount;
                } else {
                    var _avgDirection = {x: 0, y: 0};
                    for(var i = 0; i < _collisionCount; i += 1 ) {
                        var _otherInstance = _tempEntityList[|i];
                        var _nearestPointOnInst = nearest_point_on_instance(_entityComp, _otherInstance);
                        array_push(_km.debugCollisionsPoints, _nearestPointOnInst);
                        vector2d_inplace_add(_avgDirection, vector2d_subtract(_entityComp, _nearestPointOnInst));
                    }
                    show_debug_message(string_join("", random(1), "Collision Count: ", _collisionCount));
                    var _reverseDirection = vector2d_normalize(_avgDirection);
                    //rotated vector for perpindicular collision normal
                    var _collisionNormal = { x: _reverseDirection.y, y: -_reverseDirection.x };
                    
                    //project the direction
                    var _bounceScalar = dot_product(_xIterationAmount, _yIterationAmount, _collisionNormal.x, _collisionNormal.y);
                    var _finalOffset = vector2d_scale(_collisionNormal, _bounceScalar);
                    //vector2d_inplace_add(_finalOffset, _reverseDirection);
                    array_push(_km.debugReflectionVector, vector2d_scale(_finalOffset, 10));

                    var _testIteration = vector2d_add(_foilMoveAccumulator, _finalOffset);
                
                    //attempt to move it that direction of the normal.
                    if(!place_meeting(_entityComp.x + _testIteration.x, _entityComp.y + _testIteration.y, obj_solid)) {
                        vector2d_inplace_add(_entityComp, _testIteration);
                    } else {
                        var _mirrorVec = vector2d_mirror(_km.direction, _finalOffset);
                        vector2d_inplace_add(_foilMoveAccumulator, _reverseDirection);
                        vector2d_inplace_add(_foilMoveAccumulator, _mirrorVec);
                        //vector2d_inplace_add(_foilMoveAccumulator, _finalOffset);
                    }
                }
            }
        }

        _inst.x = _entityComp.x;
        _inst.y = _entityComp.y;
    }
    
    function draw(_km, _dt) {
        var _inst = _km.instance;
        var _entityComp = _inst.components.entity;
        var _xx = lerp(_entityComp.xPrevious, _entityComp.x, _dt);
        var _yy = lerp(_entityComp.yPrevious, _entityComp.y, _dt);
        

        draw_arrow(_xx, _yy, _xx + _km.direction.x * _km.speed * 4, _yy + _km.direction.y * _km.speed * 4, 6);
        var _debugPoints = array_length(_km.debugCollisionsPoints);
        for(var i = 0; i < _debugPoints; i += 1) {
            var _point = _km.debugCollisionsPoints[i];
            draw_circle_color(_point.x, _point.y, 4, c_red, c_maroon, true);
        }
        _debugPoints = array_length(_km.debugReflectionVector);
        for(var i = 0; i < _debugPoints; i += 1) {
            var _point = _km.debugReflectionVector[i];
            draw_arrow(_entityComp.x, _entityComp.y, _entityComp.x + _point.x, _entityComp.y + _point.y, 5);
        }
    }
}