///@param {Struct.LayerManager} _layerManager
function GlobalParticleSystemManager(_layerManager) constructor {
    systems = {};
    layerManager = _layerManager;

    ///@param {any} _layer
    ///@param {real} _x
    ///@param {real} _y
    ///@param {Asset.GMParticleSystem} _part_sys_asset
    static burstAsset = function(_layer, _x, _y, _part_sys_asset) {
        var _partSys = undefined;
        if(struct_exists(systems, _layer)) {
            _partSys = struct_get(systems, _layer);
        }
        
        if(!part_system_exists(_partSys)) {
            var _layerId = layerManager.getLayer(_layer);
            _partSys = part_system_create_layer(_layerId, true);
        }
        
        part_particles_burst(_partSys, _x, _y, _part_sys_asset);
    }
    
    ///@param {any} _layer
    ///@param {real} _x
    ///@param {real} _y
    ///@param {Id.ParticleType} _partType
    ///@param {real} _count number of particles to create
    static burstType = function(_layer, _x, _y, _partType, _count) {
        var _partSys = undefined;
        if(struct_exists(systems, _layer)) {
            _partSys = struct_get(systems, _layer);
        }
        
        if(!part_system_exists(_partSys)) {
            var _layerId = layerManager.getLayer(_layer);
            _partSys = part_system_create_layer(_layerId, true);
        }
        
        part_particles_create(_partSys, _x, _y, _partType, _count);
    }
}