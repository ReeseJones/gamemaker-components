// Feather disable GM2017

#macro MASK_SIZE_POWER 6
#macro MASK_RESOLUTION 64

function EntityInstance(_instance) : Component(_instance) constructor {
    instanceRef = undefined;
    
    //General Instance Variables
    visible = true;
    solid = false;  
    layerId = "instances";
    
    //Movement and Position Instance Variables
    x = 0;
    y = 0;
    xPrevious = 0;
    yPrevious = 0;
    direction = 0;
    directionPrevious = 0;
    speed = 0;
    friction = 0;
    
    objectIndex = 0;
    
    //Sprite Properties
    spriteIndex = 0;
    imageAlpha = 1;
    imageAngle = 0;
    imageBlend = 0;
    imageXscale = 1;
    imageYscale = 1;
    
    //Mask and Bounding Box
    maskIndex = 0;
    maskWidth = 1;
    maskHeight = 1;
    
    /*
    if(sprite_exists(spriteIndex) && sprite_exists(maskIndex)) {
        maskWidth = sprite_get_width(spriteIndex);
        maskHeight = sprite_get_height(spriteIndex);
        _instance.image_xscale = maskWidth / sprite_get_width(maskIndex);
        _instance.image_yscale = maskHeight / sprite_get_height(maskIndex);
    }
    */
}

function EntityInstanceSystem(_world) : ComponentSystem(_world) constructor {
    
    /*
    function onCreate(_entityInst) {
        //Mask and Bounding Box
        _entityInst.maskIndex = instance.mask_index;
    
        if(sprite_exists(_entityInst.spriteIndex) && sprite_exists(_entityInst.maskIndex)) {
            _entityInst.maskWidth = sprite_get_width(spriteIndex);
            _entityInst.maskHeight = sprite_get_height(spriteIndex);
            instance.image_xscale = _entityInst.maskWidth / sprite_get_width(_entityInst.maskIndex);
            instance.image_yscale = _entityInst.maskHeight / sprite_get_height(_entityInst.maskIndex);
        }    
    }
    
    */
    
    function SetSize(_entityId, _xWidth, _yHeight) {
        var _entityRef = entity.getRef(_entityId);
        var _eInst = _entityRef.components.entityInstance;
        _eInst.maskWidth = _xWidth;
        _eInst.maskHeight = _yHeight;
        _eInst.image_xscale = _xWidth / sprite_get_width(_eInst.maskIndex);
        _eInst.image_yscale = _yHeight / sprite_get_height(_eInst.maskIndex);
        //TODO forward to inst props?
    }
    
    function SetImageAngle(_entityId, _rotationDegrees) {
        var _entityRef = entity.getRef(_entityId);
        var _eInst = _entityRef.components.entityInstance;
        _eInst.imageAngle = _rotationDegrees;
        //TODO forward to inst props?
        //_eInst.instanceRef.image_angle = _rotationDegrees;
    }
    
    function SetImageScale(_entityId, _xScale, _yScale) {
        var _entityRef = entity.getRef(_entityId);
        var _eInst = _entityRef.components.entityInstance;
        _eInst.imageXscale = _xScale;
        _eInst.imageYscale = _yScale;
        //TODO forward to inst props?
    }
    
    /*
    function beginStep(_entity, _dt) {
        var inst = _entity.instance;
        
        inst.visible = _entity.visible;
        inst.solid = _entity.solid;
        inst.persistent = _entity.persistent;
        //TODO: Update layer id
    
        //Movement and Position Instance Variables
        _entity.xPrevious = _entity.x;
        _entity.yPrevious = _entity.y;
        
        inst.x = _entity.x;
        inst.y = _entity.y;
    
        _entity.directionPrevious = _entity.direction;
        inst.direction = _entity.direction;
        inst.speed = _entity.speed;
        inst.friction = _entity.friction;
    
        //Sprite Properties
        inst.sprite_index = _entity.spriteIndex;
        inst.image_alpha = _entity.imageAlpha;
        inst.image_blend = _entity.imageBlend;
        
        //Mask and Bounding Box
        inst.mask_index = _entity.maskIndex;
        inst.image_xscale = _entity.maskWidth / sprite_get_width( _entity.maskIndex);
        inst.image_yscale = _entity.maskHeight / sprite_get_height( _entity.maskIndex);
        inst.image_angle = _entity.imageAngle;
    }
    */
    
    /*
    function drawEnd(_entityInst, _dt) {
        var inst = _entityInst.instance;
        var xx = inst.x
        var yy = inst.y
        var rot = _entityInst.imageAngle;
            
        //get the rotated bounding box world positions
        var bbox = rect_get_rotated(xx, yy, _entityInst.maskWidth / 2, _entityInst.maskHeight / 2, rot);
        
        draw_line_width(bbox.tl.x, bbox.tl.y, bbox.br.x, bbox.br.y, 3);
        
        //rotate them around origin back to be axis aligned
        vector2d_inplace_rotate( bbox.tl, rot);
        vector2d_inplace_rotate( bbox.br, rot);
        
        draw_line(bbox.tl.x, bbox.tl.y, bbox.br.x, bbox.tl.y);
        draw_line(bbox.br.x, bbox.tl.y, bbox.br.x, bbox.br.y);
        draw_line(bbox.br.x, bbox.br.y, bbox.tl.x, bbox.br.y);
        draw_line(bbox.tl.x, bbox.br.y, bbox.tl.x, bbox.tl.y);
    }
    */
    
    /*
    function draw(_entityInst, _dt) {
        var inst = _entityInst.instance;
        var xx = lerp(_entityInst.xPrevious, _entityInst.x, _dt);
        var yy = lerp(_entityInst.yPrevious, _entityInst.y, _dt);
        
        
        if(sprite_exists(_entityInst.spriteIndex)) {
            draw_sprite_ext(
                _entityInst.spriteIndex,
                0, 
                xx,
                yy, 
                _entityInst.imageXscale,
                _entityInst.imageYscale, 
                _entityInst.imageAngle,
                _entityInst.imageBlend,
                0.3
            );
        }
        
        if(sprite_exists(inst.mask_index)) {
            draw_sprite_ext(
                inst.mask_index,
                0,
                inst.x,
                inst.y,
                inst.image_xscale,
                inst.image_yscale,
                inst.image_angle,
                c_white,
                0.4
            );
        }
    }
    */
}
