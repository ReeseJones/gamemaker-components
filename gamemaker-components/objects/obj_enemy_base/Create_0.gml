enemyAttributes = new EnemyAttributes();
alive = true;
collisionCount = 0;
maxCollisionResponses = 3;
maxHealth = 1;
currentHealth = maxHealth;

tempVec = new Vec2();
tempVec2 = new Vec2();
sprite_index = choose(spr_enemy_slug, spr_enemy_stone_grub, spr_alien_bug);
