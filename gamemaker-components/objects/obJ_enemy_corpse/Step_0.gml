/// @description Insert description here
// You can write your code in this editor
var _progress = 1 - clamp(alarm_get(0) / lifetime, 0, 1);
image_alpha = animcurve_channel_evaluate(fadeOutCurveChannel, _progress);

hspeed *= 0.94;
vspeed *= 0.94;