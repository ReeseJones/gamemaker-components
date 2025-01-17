function enemy_apply_damage(_enemy, _damage) {
    _enemy.currentHealth -= _damage;
    
    if(_enemy.currentHealth <= 0) {
        var _layerId = obj_game.layerManager.getLayer("corpses");
        var _corpse = instance_create_layer(_enemy.x, _enemy.y, _layerId, obJ_enemy_corpse);

        _corpse.sprite_index = _enemy.sprite_index;
        _corpse.image_angle = _enemy.image_angle;
        _corpse.image_index = _enemy.image_index;
        _corpse.image_speed = 0.05;
        _corpse.vspeed = _enemy.vspeed;
        _corpse.hspeed = _enemy.hspeed;


        instance_destroy(_enemy);
        //TODO: Make better enemy tracking system than this;
        obj_arena_manager.enemyManager.untrackEnemy(_enemy);
    }
}