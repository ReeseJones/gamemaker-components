///@param {any} _structOrInstance
///@param {string} _key
function has(_structOrInstance, _key) {
    if( is_struct(_structOrInstance) ) {
        return struct_exists(_structOrInstance, _key);
    } else if( instance_exists(_structOrInstance) ) {
        return variable_instance_exists(_structOrInstance, _key)
    }

    return false;
}