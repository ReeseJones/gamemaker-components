// Self away from enemy;
//A -> B means subtract B - A
var _otherEnemey = other.id;

tempVec.x = x;
tempVec.y = y;
tempVec.x -= _otherEnemey.x;
tempVec.y -= _otherEnemey.y;
if (tempVec.x == 0 && tempVec.y == 0) {
    return;
}
var _length = sqrt(tempVec.x*tempVec.x + tempVec.y*tempVec.y);
tempVec.x /= _length;
tempVec.y /= _length;
//if needed can scale speed
//tempVec.x *= 1;
//tempVec.y *= 1;
x += tempVec.x;
y += tempVec.y;
x -= hspeed / maxCollisionResponses;
y -= vspeed / maxCollisionResponses;