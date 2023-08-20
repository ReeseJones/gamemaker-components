event_inherited();

onMouseOver = function() {
    image_blend = c_red;
}

onMouseOut = function() {
    image_blend = c_white;
}


onClicked = function(_button) {
    if(_button == mb_left) {
        var _inst = instance_create_depth(mouse_x - 200, mouse_y, 0, obj_mech_component);
        
        _inst.component.spriteIndex = sprite_index;
        
        _inst.componentBinding.updateAll();
    }
}