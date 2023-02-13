draw_sprite_ext(
	sprite_index,
	image_index,
	lerp(realXPrev, x, world.tickProgress),
	lerp(realYPrev, y, world.tickProgress),
	image_xscale,
	image_yscale,
	realDirPrev - lerp(0, angle_difference(realDirPrev, direction), world.tickProgress),
	image_blend,
	image_alpha
)