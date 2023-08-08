#macro MASK_SIZE_POWER 6
#macro MASK_RESOLUTION 64

///@param {Struct.Entity} _entity
function EntityInstance(_entity) : Component(_entity) constructor {
    static name = string_lowercase_first(instanceof(self));
    // Feather disable GM2017
    instance = undefined;

    //General Instance Variables
    visible = true;
    solid = false;

    layerName = "instances";
    layer = -1;

    //Movement and Position Instance Variables
    x = 0;
    y = 0;
    xPrevious = 0;
    yPrevious = 0;
    direction = 0;
    directionPrevious = 0;
    speed = 0;
    friction = 0;

    objectIndex = obj_solid_dynamic;

    //Sprite Properties
    spriteIndex = spr_mask_circle;
    //TODO: Image Index??? Image Speed?
    imageAlpha = 1;
    imageAngle = 0;
    imageBlend = 0;
    imageXScale = 1;
    imageYScale = 1;

    //Mask and Bounding Box
    maskIndex = spr_mask_circle;
    maskWidth = 64;
    maskHeight = 64;
    // Feather restore GM2017
}

function EntityInstanceSystem() : ComponentSystem() constructor {
    static componentConstructor = EntityInstance;
    static componentName = string_lowercase_first(script_get_name(componentConstructor));

    ///@param {Struct.EntityInstance} _entityInst
    static onCreate = function(_entityInst) {
        setObject(_entityInst.getEntityId(), _entityInst.objectIndex, _entityInst.layerName);
    }

    ///@param {Struct.EntityInstance} _entityInst
    static onDestroy = function(_entityInst) {
        instance_destroy(_entityInst.instance);
        _entityInst.instance = -1;
    }

    ///@param {Real} _entityId
    ///@param {Asset.GMObject} _newObjectIndex
    ///@param {String} _newLayerId
    static setObject = function(_entityId, _newObjectIndex, _newLayerId) {
        var _entity = world.getRef(_entityId);
        var _entityInst = _entity.component.entityInstance;
        //cleanup old object
        if(instance_exists(_entityInst.instance)) {
            instance_destroy(_entityInst.instance);
            _entityInst.instance = -1;
        }

        if(object_exists(_newObjectIndex)) {
            _entityInst.objectIndex = _newObjectIndex;
        } else {
            throw string_join("", "EntityInstance.setObject: Object with index ", _newObjectIndex, " does not exist.");
        }

        if(layer_exists(_newLayerId)) {
            if(is_real(_newLayerId)) {
                _entityInst.layer = _newLayerId;
                _entityInst.layerName = layer_get_name(_newLayerId);
            } else {
                _entityInst.layer = layer_get_id(_newLayerId);
                _entityInst.layerName = _newLayerId;
            }
        } else {
            throw string_join("", "EntityInstance.setObject: Cannot create object since layer does not exist: ", _newLayerId);
        }

        _entityInst.instance = instance_create_layer(
            _entityInst.x,
            _entityInst.y,
            _entityInst.layer,
            _entityInst.objectIndex
        );
        
        if(sprite_exists(_entityInst.spriteIndex) && sprite_exists(_entityInst.maskIndex)) {
            _entityInst.maskWidth = sprite_get_width(_entityInst.spriteIndex);
            _entityInst.maskHeight = sprite_get_height(_entityInst.spriteIndex);
            _entityInst.imageXScale = _entityInst.maskWidth / sprite_get_width(_entityInst.maskIndex);
            _entityInst.imageYScale = _entityInst.maskHeight / sprite_get_height(_entityInst.maskIndex);
        }
            
        //TODO: Fix when can assert types
        // Feather disable once GM1041
        entity_instance_sync_instance(_entityInst, _entityInst.instance);
    }
    
    ///@param {Real} _entityId
    ///@param {Real} _xWidth
    ///@param {Real} _yHeight
    static setSize = function(_entityId, _xWidth, _yHeight) {
        var _entity = world.getRef(_entityId);
        var _entityInst = _entity.component.entityInstance;

        _entityInst.maskWidth = _xWidth;
        _entityInst.maskHeight = _yHeight;

        _entityInst.imageXScale = _xWidth / sprite_get_width(_entityInst.maskIndex);
        _entityInst.imageYScale = _yHeight / sprite_get_height(_entityInst.maskIndex);

        var _inst = _entityInst.instance;
        _inst.image_xscale = _entityInst.imageXScale;
        _inst.image_yscale = _entityInst.imageYScale;
    }
    
    ///@param {Real} _entityId
    ///@param {Real} _rotationDegrees
    static setImageAngle = function(_entityId, _rotationDegrees) {
        var _entity = world.getRef(_entityId);
        var _entityInst = _entity.component.entityInstance;

        _entityInst.imageAngle = _rotationDegrees;
        _entityInst.instance.image_angle = _rotationDegrees;
    }

    ///@param {Struct.EntityInstance} _entityInstance
    ///@param {Real} _dt
    static beginStep = function(_entityInstance, _dt) {
        var _inst = _entityInstance.instance;

        //Movement and Position Instance Variables
        _entityInstance.xPrevious = _entityInstance.x;
        _entityInstance.yPrevious = _entityInstance.y;
        _entityInstance.directionPrevious = _entityInstance.direction;
        
        //TODO Sync component properties to instance???
        entity_instance_sync_instance(_entityInstance, _inst);
    }

    ///@param {Struct.EntityInstance} _entityInstance
    ///@param {Real} _dt
    static drawEnd = function(_entityInstance, _dt) {
        var _inst = _entityInstance.instance;
        var _xx = _inst.x
        var _yy = _inst.y
        var _rot = _entityInstance.imageAngle;

        //get the rotated bounding box world positions
        var _bbox = rect_get_rotated(_xx, _yy, _entityInstance.maskWidth / 2, _entityInstance.maskHeight / 2, _rot);

        draw_line_width(_bbox.tl.x, _bbox.tl.y, _bbox.br.x, _bbox.br.y, 3);

        //rotate them around origin back to be axis aligned
        vector2d_inplace_rotate( _bbox.tl, _rot);
        vector2d_inplace_rotate( _bbox.br, _rot);

        draw_line(_bbox.tl.x, _bbox.tl.y, _bbox.br.x, _bbox.tl.y);
        draw_line(_bbox.br.x, _bbox.tl.y, _bbox.br.x, _bbox.br.y);
        draw_line(_bbox.br.x, _bbox.br.y, _bbox.tl.x, _bbox.br.y);
        draw_line(_bbox.tl.x, _bbox.br.y, _bbox.tl.x, _bbox.tl.y);
    }

    ///@param {Struct.EntityInstance} _entityInstance
    ///@param {Real} _dt
    static draw = function(_entityInstance, _dt) {
        var _inst = _entityInstance.instance;
        var _xx = lerp(_entityInstance.xPrevious, _entityInstance.x, _dt);
        var _yy = lerp(_entityInstance.yPrevious, _entityInstance.y, _dt);

        if(sprite_exists(_entityInstance.spriteIndex)) {
            draw_sprite_ext(
                _entityInstance.spriteIndex,
                0, 
                _xx,
                _yy, 
                _entityInstance.imageXScale,
                _entityInstance.imageYScale, 
                _entityInstance.imageAngle,
                _entityInstance.imageBlend,
                0.3
            );
        }

        if(sprite_exists(_inst.mask_index)) {
            draw_sprite_ext(
                _inst.mask_index,
                0,
                _inst.x,
                _inst.y,
                _inst.image_xscale,
                _inst.image_yscale,
                _inst.image_angle,
                c_white,
                0.4
            );
        }
    }
}
