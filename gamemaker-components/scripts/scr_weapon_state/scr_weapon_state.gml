struct_save_static(nameof(WeaponState), WeaponState);
function WeaponState(_trgCldn = 0, _shtCldwn = 0) : Disposable() constructor {
    triggerCooldown = _trgCldn;
    shotCooldown = _shtCldwn;
    currentShotCount = 0;
    isTriggering = false;
    triggerWhenReady = false;
    projectileSpawnLocation = new Vec2();
    projectileSpawnAngle = 0;
    particleSystem = part_system_create_layer(obj_game.layerManager.getLayer("floorLow"), true);
    
    static dispose = function() {
        part_system_destroy(particleSystem);
        particleSystem = undefined;
    }
}