draw_sprite_ext(
	sprite_index,
	image_index,
	lerp(real_xprev, x, world.tickProgress),
	lerp(real_yprev, y, world.tickProgress),
	image_xscale,
	image_yscale,
	real_dirpriv - lerp(0, angle_difference(real_dirpriv, direction), world.tickProgress),
	image_blend,
	image_alpha
)