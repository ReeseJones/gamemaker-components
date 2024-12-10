//Attempts to add stability to gittery enemies.
if(collisionCount >= maxCollisionResponses) {
    return;
}

// Self away from enemy;
//A -> B means subtract B - A
var _otherEnemey = other.id;

tempVec.x = x;
tempVec.y = y;
tempVec.x -= _otherEnemey.x;
tempVec.y -= _otherEnemey.y;
var _length = sqrt(tempVec.x*tempVec.x + tempVec.y*tempVec.y);
tempVec.x /= _length;
tempVec.y /= _length;
tempVec.x *= 1;
tempVec.y *= 1;
x += tempVec.x;
y += tempVec.y;
x -= hspeed / maxCollisionResponses;
y -= vspeed / maxCollisionResponses;

collisionCount += 1;