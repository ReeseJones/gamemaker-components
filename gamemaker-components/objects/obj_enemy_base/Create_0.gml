enemyAttributes = new EnemyAttributes();
currentTarget = new Vec2();
bloodParticles = part_system_create();
alive = true;
part_system_layer(bloodParticles, layer_get_id("floorLow"));