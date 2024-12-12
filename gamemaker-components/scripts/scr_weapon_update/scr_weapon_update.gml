



///@desc weapon_update_state updates weapon state.
///@param {Struct.WeaponState} _state
///@param {Struct.WeaponAttributes} _attributes
///@param {Struct.WeaponStyle} _style
function weapon_update_state(_state, _attributes, _style) {
    var _frameDeltaTime = game_get_speed(gamespeed_microseconds) / MICROSECONDS_PER_SECOND;
    _state.triggerCooldown -= _frameDeltaTime;
    _state.shotCooldown -= _frameDeltaTime;

    if (_state.triggerWhenReady && !_state.isTriggering && _state.triggerCooldown < 0) {
        _state.isTriggering = true;
        _state.triggerCooldown = _attributes.cooldown + (_attributes.shotCooldown *  _attributes.shotsPerTrigger);
        _state.shotCooldown = 0;
        _state.currentShotCount = _attributes.shotsPerTrigger;
    }


    if(_state.isTriggering) {
        if(_state.shotCooldown <= 0 && _state.currentShotCount > 0) {
            _state.currentShotCount -= 1;
            _state.shotCooldown = _attributes.shotCooldown;
            var _pos = _state.projectileSpawnLocation;
            audio_play_sound(snd_weapon_shoot_1, 1, false);
            var _weaponPartSys = _state.particleSystem;
            part_system_position(_weaponPartSys, _pos.x, _pos.y);
            part_system_angle(_weaponPartSys, _state.projectileSpawnAngle);
            part_particles_burst(_weaponPartSys, 0, 0, prt_sys_muzzle_flash);
            var _layerId = obj_game.layerManager.getLayer("instances");

            //Create projectiles for this shot
            for(var i = 0; i < _attributes.projectilesPerShot; i += 1) {
                var _projectile = instance_create_layer(_pos.x, _pos.y, _layerId, _attributes.projectile);
                _projectile.direction = _state.projectileSpawnAngle;
                _projectile.direction += random_range(-_attributes.projectileSpreadArc, _attributes.projectileSpreadArc);
                _projectile.image_angle = _projectile.direction;
            }
        }

        if( _state.currentShotCount < 1 ) {
            _state.isTriggering = false;
        }
    }
}