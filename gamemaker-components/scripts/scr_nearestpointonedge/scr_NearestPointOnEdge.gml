function NearestPointOnRectangle(_startPos, _topLeftPos, _bottomRightPos) {
	
}

function NearestPointOnCircle(_startPos, _circlePos, _radius) {
	
}

function NearestPointOnEllipse(_startPos, _circlePos, _xRadius, _yRadius) {
	
}

function NearestPointOnInstance(_startPos, _inst) {
	var nearestPoint = { x: 0, y: 0 };
	var instEntity = _inst.components.entity;
	var halfWidth = instEntity.maskWidth / 2
	var halfHeight = instEntity.maskHeight / 2
	var rot = instEntity.imageAngle;

	switch(instEntity.spriteIndex) {
		case spr_obj_solid: {
			_startPos = vector2d_rotate_around(_startPos, instEntity, rot);
			
			var dir = vector2d_direction_normalized(instEntity, _startPos);
			dir.x *= halfWidth;
			dir.y *= halfHeight;
			
			vector2d_inplace_add(nearestPoint, dir);
			vector2d_inplace_add(nearestPoint, instEntity);
			return vector2d_rotate_around(nearestPoint, instEntity, -rot);
			
			/*
			return nearest_point_on_ellipse(
				_startPos.x,
				_startPos.y,
				halfWidth,
				halfHeight,
				instEntity.x,
				instEntity.y,
				rot
			);
			*/
		}

		case spr_obj_solid_rectangle: {
			var xx = instEntity.x;
			var yy = instEntity.y;
			
			//get the rotated bounding box world positions
			var bbox = rect_get_rotated(xx, yy, halfWidth, halfHeight, rot);
			
			//rotate them around origin back to be axis aligned
			vector2d_inplace_rotate( bbox.tl, rot);
			vector2d_inplace_rotate( bbox.br, rot);
			
			//do the same rotation to the starting position
			var startPos = vector2d_rotate(_startPos, rot);
			//perform the check
			nearestPoint.x = clamp(startPos.x, bbox.tl.x, bbox.br.x);
			nearestPoint.y = clamp(startPos.y, bbox.tl.y, bbox.br.y);
			//rotate the point back
			return vector2d_inplace_rotate(nearestPoint, -rot);
		}
		
		default:
		throw "instance edge could not be found";
	}
}