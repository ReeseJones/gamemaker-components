function EnemyManager() constructor {
    enemies = [];
    enemyTarget = new Vec2();
    tempVec = new Vec2();
    
    static step = function() {
        
        var _dt = game_get_speed(gamespeed_microseconds) / MICROSECONDS_PER_SECOND;
        
        if(instance_exists(obj_player_base)) {
            enemyTarget.x = obj_player_base.x;
            enemyTarget.y = obj_player_base.y;
        }
        
        for(var i = 0, _len = array_length(enemies); i < _len; i += 1) {
            var _enemy = enemies[i];
            var _attributes = _enemy.enemyAttributes;
            //var _target = _enemy.currentTarget;
            var _target = enemyTarget;
            
            if(!_enemy.alive) {
                continue;
            }
            
            tempVec.x = _target.x;
            tempVec.y = _target.y;
            tempVec.x -= _enemy.x;
            tempVec.y -= _enemy.y;
            var _length = sqrt(tempVec.x * tempVec.x + tempVec.y * tempVec.y);
            
            if(_length > 0) {
                tempVec.x /= _length;
                tempVec.y /= _length;
                var _stepLength = _attributes.movementSpeed * _dt;
                tempVec.x *= _stepLength;
                tempVec.y *= _stepLength;
                //_enemy.x += tempVec.x;
                //_enemy.y += tempVec.y;
                _enemy.hspeed = tempVec.x;
                _enemy.vspeed = tempVec.y;
                _enemy.image_angle = point_direction(0, 0, tempVec.x, tempVec.y);
            }
        }
    }
    
    static createEnemies = function() {
        var _layerid = obj_game.layerManager.getLayer("instances");
        var _newEnemy = instance_create_layer(random(room_width), random(room_height), _layerid, obj_enemy_base);
        array_push(enemies, _newEnemy);
        show_debug_message($"Enemies: {array_length(enemies)}");
    }

}