/// @description Step Event

real_xprev = x;
real_yprev = y;
real_dirpriv = direction;

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

if(real_xprev != x || real_yprev != y) {
	direction = point_direction(real_xprev, real_yprev, x, y);
}
