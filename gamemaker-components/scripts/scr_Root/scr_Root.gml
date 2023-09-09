function root_get() {
    if(instance_exists(obj_game)) {
        return obj_game.id;
    } else {
        return instance_create_depth(0,0,1000, obj_game);
    }
}