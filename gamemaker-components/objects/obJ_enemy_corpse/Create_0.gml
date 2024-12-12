lifetime = 300;
/// @description Insert description here
// You can write your code in this editor
alarm[0] = lifetime;

fadeOutCurve = ac_enemy_corpse_fade;


if(!animcurve_exists(fadeOutCurve)) {
    throw "This curve doesnt exist!";
}

fadeOutCurveChannel = animcurve_get_channel(fadeOutCurve, "Alpha");
audio_play_sound(choose(snd_blood_01, snd_blood_02), 1, false, 1, undefined, random_range(0.8, 1.2));
