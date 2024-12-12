
if( collisionCount < 1) {
    enemy_apply_damage(other.id, projectileDamage);
    instance_destroy();
}


collisionCount += 1;
