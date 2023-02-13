/// @description Step Event

realXPrev = x;
realYPrev = y;
realDirPrev = direction;

if( keyboard_check(ord("W")) ) {
	y -= 200 * world.tickDt;	
}

if( keyboard_check(ord("S")) ) {
	y += 200 * world.tickDt;	
}

if( keyboard_check(ord("A")) ) {
	x -= 200 * world.tickDt;	
}

if( keyboard_check(ord("D")) ) {
	x += 200 * world.tickDt;	
}

if(realXPrev != x || realYPrev != y) {
	direction = point_direction(realXPrev, realYPrev, x, y);
}
