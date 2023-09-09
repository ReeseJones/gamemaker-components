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

        var _sockets = [];
        var _socketCount = array_length(_compData.socketPositions);

        for(var i = 0; i < _socketCount; i += 1) {
            var _sockData = _compData.socketPositions[i];
            var _newSocket = new MechSocket(_sockData.x, _sockData.y);
            array_push(_sockets, _newSocket);
        }
        
        var _newMechComponent = new MechComponent( _compData.width, _compData.height, _sockets);
        
        _newMechComponent.name = _compData.name;
        _newMechComponent.dataId = _componentDataId;
        _newMechComponent.spriteIndex = _compData.spriteIndex;
        
        _inst.component = _newMechComponent;
        _inst.componentBinding.setBoundComponent(_newMechComponent);

        return _inst;
    }
}

//global.mechComponentFactory = new MechComponentFactory(global.mechComponentDataProvider);