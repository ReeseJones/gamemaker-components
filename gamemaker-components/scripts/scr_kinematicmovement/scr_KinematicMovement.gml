function KinematicMovement(_instance) : Component(_instance) constructor {
	direction = { x: 1, y: 0 };
	speed = 0;
	mass = 1;
	debugCollisionsPoints = [];
	debugReflectionVector = [];
}

function KinematicMovementSystem(_world) : ComponentSystem(_world) constructor {
	
	entityCollisionList = undefined;	
	
	function SystemStart() {
		entityCollisionList = ds_list_create();
	}
	
	function SystemCleanup() {
		ds_list_destroy(entityCollisionList);
	}
	
	function SetSpeed(_entityId, _speed) {
		var inst = entity.GetRef(_entityId);
		var km = inst.components.kinematicMovement;
		km.speed = _speed;
	}
	
	function SetDirectionVector(_entityId, _x, _y) {
		var inst = entity.GetRef(_entityId);
		var km = inst.components.kinematicMovement;
		var length = sqrt(_x*_x + _y*_y);
		km.direction.x = _x / length;
		km.direction.y = _y / length;
	}
	
	function SetDirectionAngle(_entityId, _angleDegrees) {
		var inst = entity.GetRef(_entityId);
		var km = inst.components.kinematicMovement;
		var angleInRads = degtorad(_angleDegrees);
		km.direction.x = cos(angleInRads);
		//inverting sign because postive y is down in game maker
		km.direction.y = -sin(angleInRads);
	}
	
	function Create(_km) {
		with(_km.instance) {
			show_debug_message("Testing start collisions");
			var _list = ds_list_create();
			var _num = instance_place_list(x, y, obj_solid, _list, false);

		    for (var i = 0; i < _num; ++i)
		    {
				show_debug_message("Removed starting instance");
		        instance_destroy(_list[| i]);
		    }

			ds_list_destroy(_list);
		}
	}
	
	function Step(_km, _dt) {
		array_resize(_km.debugCollisionsPoints, 0 );
		array_resize(_km.debugReflectionVector, 0 );
		var tempEntityList = entityCollisionList;
		var inst = _km.instance;
		var entityComp = inst.components.entity;
		if(_km.speed == 0) {
			//static objects do not need to be updated.
			return;	
		}
		if(_km.direction.x == 0 && _km.direction.y == 0) {
			//objects with no direction cannot move
			return;	
		}

		var xOffset = _km.direction.x * _km.speed;
		var yOffset = _km.direction.y * _km.speed;
		var iterations = min(8, round(_km.speed));
		var currentIteration = 0;
		var xIterationAmount = xOffset / iterations;
		var yIterationAmount = yOffset / iterations;
		var foilMoveAccumulator = {x: 0, y: 0};
		
		var entityId = _km.GetEntityId();
		
		//TODO: TEMP CODE: Point towards mouse
		var dir = point_direction(entityComp.x, entityComp.y, mouse_x, mouse_y);
		SetDirectionAngle(entityId, dir);
				
		with(inst) {
			for(currentIteration = 0; currentIteration < iterations; currentIteration += 1) {
				ds_list_clear(tempEntityList);
				var collisionCount = instance_place_list(entityComp.x + xIterationAmount, entityComp.y + yIterationAmount, obj_solid, tempEntityList, true);
				
				if(collisionCount == 0) {
					entityComp.x += xIterationAmount;
					entityComp.y += yIterationAmount;
				} else {
					var avgDirection = {x: 0, y: 0};
					for(var i = 0; i < collisionCount; i += 1 ) {
						var otherInstance = tempEntityList[|i];
						var nearestPointOnInst = NearestPointOnInstance(entityComp, otherInstance);
						array_push(_km.debugCollisionsPoints, nearestPointOnInst);
						vector2d_inplace_add(avgDirection, vector2d_subtract(entityComp, nearestPointOnInst));
					}
					show_debug_message(String(random(1), "Collision Count: ", collisionCount));			
					var reverseDirection = vector2d_normalize(avgDirection);		
					//rotated vector for perpindicular collision normal
					var collisionNormal = { x: reverseDirection.y, y: -reverseDirection.x };
					
					//project the direction
					var bounceScalar = dot_product(xIterationAmount, yIterationAmount, collisionNormal.x, collisionNormal.y);
					var finalOffset = vector2d_scale(collisionNormal, bounceScalar);
					//vector2d_inplace_add(finalOffset, reverseDirection);
					array_push(_km.debugReflectionVector, vector2d_scale(finalOffset, 10));

					var testIteration = vector2d_add(foilMoveAccumulator, finalOffset);
				
					//attempt to move it that direction of the normal.
					if(!place_meeting(entityComp.x + testIteration.x, entityComp.y + testIteration.y, obj_solid)) {
						vector2d_inplace_add(entityComp, testIteration);
					} else {
						var mirrorVec = vector2d_mirror(_km.direction, finalOffset);
						vector2d_inplace_add(foilMoveAccumulator, reverseDirection);
						vector2d_inplace_add(foilMoveAccumulator, mirrorVec);
						//vector2d_inplace_add(foilMoveAccumulator, finalOffset);
					}
				}
			}
		}
		
		inst.x = entityComp.x;
		inst.y = entityComp.y;
	}
	
	function Draw(_km, _dt) {
		var inst = _km.instance;
		var entityComp = inst.components.entity;
		var xx = lerp(entityComp.xPrevious, entityComp.x, _dt);
		var yy = lerp(entityComp.yPrevious, entityComp.y, _dt);
		

		draw_arrow(xx, yy, xx + _km.direction.x * _km.speed * 4, yy + _km.direction.y * _km.speed * 4, 6);
		var debugPoints = array_length(_km.debugCollisionsPoints);
		for(var i = 0; i < debugPoints; i += 1) {
			var point = _km.debugCollisionsPoints[i];
			draw_circle_color(point.x, point.y, 4, c_red, c_maroon, true);
		}
		debugPoints = array_length(_km.debugReflectionVector);
		for(var i = 0; i < debugPoints; i += 1) {
			var point = _km.debugReflectionVector[i];
			draw_arrow(entityComp.x, entityComp.y, entityComp.x + point.x, entityComp.y + point.y, 5);
		}
	}
}