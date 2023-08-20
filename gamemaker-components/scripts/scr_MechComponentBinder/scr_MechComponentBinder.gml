/// @function MechComponentBinder
/// @param {Id.Instance}            _boundInstance
/// @param {Struct.MechComponent}   _component
function MechComponentBinder(_boundInstance, _component) constructor {
    boundInstance = _boundInstance;
    component = _component;

    updateAll();
    
    static updateObjectSize = function() {
        var _width = component.width * MECH_CELL_SIZE;
        var _height = component.height * MECH_CELL_SIZE;

        object_set_size(boundInstance, _width, _height, component.spriteIndex);
    }
    
    static updateAppearance = function() {
        boundInstance.sprite_index = component.spriteIndex;
    }
    
    static updateAll = function() {
        updateObjectSize();
        updateAppearance();
    }
}