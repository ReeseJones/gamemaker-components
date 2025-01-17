///@param {Struct} _layerBlueprint A map of layer names to their depth
///@param {Struct.LoggingService} _logger;
function LayerManager(_layerBlueprint, _logger) constructor {
    layerBlueprint = _layerBlueprint;
    logger = _logger;

    static getLayer = function(_name) {
        if(layer_exists(_name)) {
            return layer_get_id(_name);
        }
        
        if(struct_exists(layerBlueprint, _name)) {
            var _layerDepth = struct_get(layerBlueprint, _name);
            
            return layer_create(_layerDepth, _name);
        }
        
        logger.logError(LOG_LEVEL.URGENT, $"Warning: layer with name {_name} has no blueprint. default layer created at depth 0.");
        return layer_create(0, _name);
    }

    static useLayerBlueprint = function(_layerBlueprint) {
        if(!is_struct(_layerBlueprint)) {
            throw $"_layerBlueprint is not a struct";
        }
        layerBlueprint = _layerBlueprint;
        
        updateLayers();
    }
    
    static updateLayers = function() {
        var _layers = struct_get_names(layerBlueprint)

        array_foreach(_layers, method(self, function(_layerName) {
            var _layer = getLayer(_layerName);
            var _layerDepth = struct_get(layerBlueprint, _layerName);
            layer_depth(_layer, _layerDepth);
        }));
    }
    
    updateLayers();
}