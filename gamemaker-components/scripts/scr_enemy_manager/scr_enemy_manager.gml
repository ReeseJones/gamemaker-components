function EnemyManager() constructor {
    enemies = [];
    enemyTarget = new Vec2();
    
    static step = function() {
        
        var _dt = game_get_speed(gamespeed_microseconds) / MICROSECONDS_PER_SECOND;
        
        if(instance_exists(obj_weapon)) {
            enemyTarget.x = obj_weapon.x;
            enemyTarget.y = obj_weapon.y;
        }
        
        for(var i = 0, _len = array_length(enemies); i < _len; i += 1) {
            var _enemy = enemies[i];
            var _attributes = _enemy.enemyAttributes;
            //var _target = _enemy.currentTarget;
            var _target = enemyTarget;
            
            if(!_enemy.alive) {
                continue;
            }
            
            var _vec = obj_game.vectorPool2d.getEntity();
            
            _vec.x = _target.x;
            _vec.y = _target.y;
            
            vector2d_inplace_subtract(_vec, _enemy);
            vector2d_inplace_normalize(_vec);
            vector2d_inplace_scale(_vec, _attributes.movementSpeed * _dt);
            
            vector2d_inplace_add(_enemy, _vec);
            _enemy.image_angle = point_direction(0, 0, _vec.x, _vec.y);
            
            obj_game.vectorPool2d.doneWithEntity(_vec);
        }
    }
    
    static createEnemies = function() {
        var _layerid = layer_get_id("Instances");
        var _newEnemy = instance_create_layer(random(room_width), random(room_height), _layerid, obj_enemy_base);
        array_push(enemies, _newEnemy);
    }

}