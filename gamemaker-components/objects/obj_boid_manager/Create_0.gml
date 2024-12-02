/// @description Insert description here
// You can write your code in this editor

steeringProperties = new BoidSteeringProperties();
spatialGrid = new SpatialGrid(room_width, room_height, round(room_width / 100), round(room_height / 100));

boidCount = 300;
boidList = array_create(boidCount);
for( var i = 0; i < boidCount; i += 1) {
    var _boid = new Boid();
    boidList[i] = _boid;
    _boid.position.x = random_range(0, room_width);
    _boid.position.y = random_range(0, room_height);
    _boid.velocity.x = random_range(-1, 1);
    _boid.velocity.y = random_range(-1, 1);
}

//bounds = new Box(room_height / 4, room_width / 4, room_height * 0.75, room_width * 0.75);
bounds = new Box(0, 0, room_height, room_width);
tempBoidIds = [];
getBoidRef = method(id, function(_id) {
    return boidList[_id];
});
