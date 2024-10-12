/// @description Insert description here
// You can write your code in this editor

for( var i = 0; i < boidCount; i += 1) {
    var _boid = boidList[i];
    var _angle = point_direction(0, 0, _boid.velocity.x, _boid.velocity.y);
    draw_sprite_ext(spr_boid_triangle, 0, _boid.position.x, _boid.position.y, 1, 1, _angle, c_white, 1);
    //draw_circle_color(_boid.position.x, _boid.position.y, steeringProperties.viewRadius, c_blue, c_blue, true);
    //draw_circle_color(_boid.position.x, _boid.position.y, steeringProperties.seperationDistance, c_lime, c_lime, true);
    //draw_circle_color(_boid.position.x, _boid.position.y, steeringProperties.alignmentDistance, c_aqua, c_aqua, true);
}