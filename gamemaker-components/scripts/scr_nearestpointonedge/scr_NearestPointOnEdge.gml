function nearest_point_on_rectangle(_startPos, _topLeftPos, _bottomRightPos) {

}

function nearest_point_on_circle(_startPos, _circlePos, _radius) {

}

function nearest_point_on_instance(_startPos, _inst) {
    var _nearestPoint = { x: 0, y: 0 };
    var _instEntity = _inst.components.entity;
    var _halfWidth = _instEntity.maskWidth / 2
    var _halfHeight = _instEntity.maskHeight / 2
    var _rot = _instEntity.imageAngle;

    switch(_instEntity.spriteIndex) {
        case spr_obj_solid: {
            _startPos = vector2d_rotate_around(_startPos, _instEntity, _rot);

            var _dir = vector2d_direction_normalized(_instEntity, _startPos);
            _dir.x *= _halfWidth;
            _dir.y *= _halfHeight;

            vector2d_inplace_add(_nearestPoint, _dir);
            vector2d_inplace_add(_nearestPoint, _instEntity);
            return vector2d_rotate_around(_nearestPoint, _instEntity, -_rot);

            /*
            return nearest_point_on_ellipse(
                _startPos.x,
                _startPos.y,
                _halfWidth,
                _halfHeight,
                _instEntity.x,
                _instEntity.y,
                _rot
            );
            */
        }

        case spr_obj_solid_rectangle: {
            var _xx = _instEntity.x;
            var _yy = _instEntity.y;
            
            //get the rotated bounding box world positions
            var _bbox = rect_get_rotated(_xx, _yy, _halfWidth, _halfHeight, _rot);
            
            //rotate them around origin back to be axis aligned
            vector2d_inplace_rotate( _bbox.tl, _rot);
            vector2d_inplace_rotate( _bbox.br, _rot);
            
            //do the same rotation to the starting position
            var _startPosRot = vector2d_rotate(_startPos, _rot);
            //perform the check
            _nearestPoint.x = clamp(_startPosRot.x, _bbox.tl.x, _bbox.br.x);
            _nearestPoint.y = clamp(_startPosRot.y, _bbox.tl.y, _bbox.br.y);
            //rotate the point back
            return vector2d_inplace_rotate(_nearestPoint, -_rot);
        }

        default:
        throw "instance edge could not be found";
    }
}