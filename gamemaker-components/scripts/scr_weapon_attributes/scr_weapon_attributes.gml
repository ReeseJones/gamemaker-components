struct_save_static(nameof(WeaponAttributes), WeaponAttributes)
function WeaponAttributes() constructor {
    // Seconds before next trigger
    cooldown = 0.4;
    // Bullets created per shot
    projectilesPerShot = 5;
    // How many times the weapon shoots per time its triggered (a burst fire weapon might shoot 2 - 3 times)
    shotsPerTrigger = 3;
    // How many seconds pass between shots of a single trigger
    shotCooldown = 0.10;
    // The maxium angle offset from the aimed direction at which a projectile may fire.
    projectileSpreadArc = 6;
    //What bullet spawns
    projectile = obj_bullet;
}