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



var _maxViewRange = 300;
var _mouseDirection = new Vec2(window_mouse_get_x(), window_mouse_get_y());
show_debug_message($"Raw Mouse View Pos: {_mouseDirection}");
//show_debug_message($"MouseDirection: {_mouseDirection}" );
var _viewportSize = new Vec2(window_get_width(), window_get_height());
show_debug_message($"Viewport size{_viewportSize}");


var _offset = vector2d_subtract(_viewportSize, vector2d_scale(_viewportSize, 0.5));
vector2d_inplace_subtract(_mouseDirection, _offset);
vector2d_inplace_scale2(_mouseDirection, new Vec2(1 / _viewportSize.x, 1 / _viewportSize.y));
show_debug_message($"Normalized Mouse Pos: {_mouseDirection}" );

obj_camera.target.x = x + _mouseDirection.x * _maxViewRange;
obj_camera.target.y = y + _mouseDirection.y * _maxViewRange;

//show_debug_message($"Camera: {obj_camera.target}");