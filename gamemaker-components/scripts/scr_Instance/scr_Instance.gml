///@param {Struct.EntityInstance} _source
///@param {Id.Instance} _dest
function entity_instance_sync_instance(_source, _dest) {
    //General Instance Variables
    _dest.visible = _source.visible;
    _dest.solid = _source.solid;
    _dest.layer = _source.layer;

    //Movement and Position Instance Variables
    _dest.x = _source.x;
    _dest.y = _source.y;
    _dest.direction = _source.direction;
    _dest.speed =_source.speed;
    _dest.friction = _source.friction;
        
    //Sprite Properties
    _dest.sprite_index = _source.spriteIndex;
    _dest.image_alpha = _source.imageAlpha;
    _dest.image_angle = _source.imageAngle;
    _dest.image_blend = _source.imageBlend;
    _dest.image_yscale = _source.imageYScale;
    _dest.image_xscale = _source.imageXScale;
    //TODO: Image Index??? Image Speed?

    //Mask and Bounding Box
    _dest.mask_index = _source.maskIndex;
}

function instance_sync_properties() {
    
}