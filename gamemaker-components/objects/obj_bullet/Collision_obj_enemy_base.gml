if(other.id != prevCollider) {
    prevCollider = other.id;
    collisionCount += 1;
    enemy_apply_damage(other.id, projectileDamage);
    
    if(collisionCount >= maxCollisions) {
        instance_destroy();
    }
}


