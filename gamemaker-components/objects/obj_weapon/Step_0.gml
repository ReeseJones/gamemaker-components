var _dir = point_direction(x, y, mouse_x, mouse_y);
image_angle = _dir - 90;

state1.projectileSpawnLocation.x = 40;
state1.projectileSpawnLocation.y = -48;

state2.projectileSpawnLocation.x = -40;
state2.projectileSpawnLocation.y = -48;

transform_to_world_inplace(state1.projectileSpawnLocation, id, image_angle);
transform_to_world_inplace(state2.projectileSpawnLocation, id, image_angle);


state1.projectileSpawnAngle = image_angle + 90;
state2.projectileSpawnAngle = image_angle + 90;

weapon_update_state(state1, weaponAttributes);
weapon_update_state(state2, weaponAttributes);
