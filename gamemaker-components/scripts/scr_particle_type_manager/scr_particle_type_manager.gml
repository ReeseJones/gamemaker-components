function ParticleTypeManager() : Disposable() constructor {
    new ParticleType();
    particleTypesMap = ds_map_create();
    
    static loadBuiltInParticleTypes = function() {
        var _partSystems = asset_get_ids(asset_particlesystem);
        
        array_foreach(_partSystems, method(self, function(_partSystemId) {
            var _partSystemInfo = particle_get_info(_partSystemId);
            array_foreach(_partSystemInfo.emitters, method(self, function(_emitter) {
                if(ds_map_exists(particleTypesMap, _emitter.name)) {
                    throw $"Particle with name: {_emitter.name} already exists. Please choose unique name.";
                }
                var _particleTypeStatic = static_get(ParticleType);
                var _particleTypeClone = struct_deep_copy(_emitter.parttype);
                _particleTypeClone.name = _emitter.name;
                static_set(_particleTypeClone, _particleTypeStatic);
                ds_map_set(particleTypesMap, _emitter.name,_particleTypeClone);
            }));
        }));

        var _particleNames = ds_map_keys_to_array(particleTypesMap);
        show_debug_message($"Loaded Particles: \n{_particleNames}");
    }

    static createParticle = function(_name) {
        if(ds_map_exists(particleTypesMap, _name)) {
            throw $"Particle with name: {_name} already exists. Please choose unique name.";
        }
        
        var _newParticleIndex = part_type_create();
        var _newPartModel = new ParticleType(_newParticleIndex, _name);
        _newPartModel.applyProperties();
        ds_map_set(particleTypesMap, _name, _newPartModel);
        return _newPartModel;
    }
    
    ///@return {Struct.ParticleType}
    static getParticle = function(_name) {
        return ds_map_find_value(particleTypesMap, _name);
    }
    
    static getAllParticles = function() {
        return ds_map_values_to_array(particleTypesMap);
    }
    
    static getParticleNameArray = function() {
        return ds_map_keys_to_array(particleTypesMap);
    }
    
    static disposeFunc = function() {
        if(ds_exists(particleTypesMap, ds_type_map)) {
            ds_map_destroy(particleTypesMap);
            particleTypesMap = undefined;
            isDisposed = true;
        }
    }
    
    loadBuiltInParticleTypes();
}