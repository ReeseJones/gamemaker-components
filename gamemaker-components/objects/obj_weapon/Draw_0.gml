
var _widthCockpit = sprite_get_width(spr_mech_cockpit02) / 2;
var _heightCockpit = sprite_get_height(spr_mech_cockpit02) / 2;

draw_sprite_orig(spr_mech_cockpit02, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha, _widthCockpit, _heightCockpit);

var _widthChaingun = sprite_get_width(spr_mech_chaingun01) / 2;
var _heightChaingun = sprite_get_height(spr_mech_chaingun01);


draw_sprite_relative_orig(spr_mech_chaingun01, 0, 40, 15, 1, 1, 0, image_blend, image_alpha, _widthChaingun, _heightChaingun, id);
draw_sprite_relative_orig(spr_mech_chaingun01, 0, -40, 15, 1, 1, 0, image_blend, image_alpha, _widthChaingun, _heightChaingun, id);
