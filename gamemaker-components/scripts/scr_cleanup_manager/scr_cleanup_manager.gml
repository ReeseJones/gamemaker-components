enum CLEANABLE_ASSET {
    DISPOSABLE = 1,
    PARTICLE_SYSTEM,
}

function CleanupManager() constructor {
    items = [];
    itemType = [];

    ///@param {real} _type CLEANABLE_ASSET.TYPE
    ///@param {any} _assetRefOrId
    static clean = function(_type, _assetRefOrId) {
        array_push(items, _assetRefOrId);
        array_push(itemType, _type);
    }
    
    static runClean = function() {
        var _len = array_length(items);

        for( var i = _len - 1; i >= 0; i -= 1) {
            var _type = array_pop(itemType);
            var _item = array_pop(items);
            
            switch (_type) {
                case CLEANABLE_ASSET.DISPOSABLE:
                    _item.dispose();
                break;
                case CLEANABLE_ASSET.PARTICLE_SYSTEM:
                    if(part_system_exists(_item)) {
                        part_system_destroy(_item);
                    }
                break;
                default:
                    throw $"Asset {_type} does not have clean method.";
                break;
            }
        }
    }

}