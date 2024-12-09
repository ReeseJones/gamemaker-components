function EntityPool(_factoryFunc) constructor {
    enitites = [];
    factoryFunc = _factoryFunc;
    
    if(!is_callable(_factoryFunc)) {
        throw "Factory function is not a callable";
    }
    
    static getEntity = function() {
        if(array_length(enitites) > 0) {
            return array_pop(enitites);
        }
        return factoryFunc();
    }
    
    static doneWithEntity = function(_entity) {
        array_push(enitites, _entity);
    }
}