function root_get() {
    if(instance_exists(obj_root)) {
        return obj_root.id;
    } else {
        return instance_create_depth(0,0,0, obj_root);
    }
}