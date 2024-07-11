/// @function MechComponentFactory
/// @param {Struct.MechComponentDataProvider} _componentDataProvider
function MechComponentFactory(_componentDataProvider) constructor {

    componentDataProvider = _componentDataProvider;

/// @function createComponent(_componentDataId)
/// @param {String}   _componentDataId
/// @return {Id.Instance}
    static createComponent = function(_componentDataId) {
        var _compData = componentDataProvider.getComponentData(_componentDataId);

        if(is_undefined(_compData)) {
            throw $"could not create component. Component with Data Id {_componentDataId} does not exist";
        }

        var _inst = instance_create_depth(0, 0, 0, obj_mech_component);
        var _newMechComponent = new MechComponent(_componentDataId);

        _inst.component = _newMechComponent;
        _inst.componentData = _compData;

        _inst.sprite_index = _compData.spriteIndex;
        var _width = MECH_CELL_SIZE * _compData.width;
        var _height = MECH_CELL_SIZE * _compData.height;
        object_set_size(_inst, _width, _height);

        return _inst;
    }
}

//global.mechComponentFactory = new MechComponentFactory(global.mechComponentDataProvider);