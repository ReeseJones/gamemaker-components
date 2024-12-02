///@description ref_creates on all properties of a struct, which returns a struct with identicaly keys to the newly created references.
function ref_create_all(_root, _structName) {
    
    var _struct = undefined;
    
    if( is_struct(_root) ) {
        _struct = struct_get(_root, _structName);
    } else if (instance_exists(_root)) {
        _struct = variable_instance_get(_root, _structName);
    } else {
        throw "Root is not a struct or instance"
    }
    
    if(!is_struct(_struct)) {
        throw "_struct was not a struct";
    }
    
    var _refs = {
        ref: ref_create(_root, _structName),
        property: {}
    };
    
    var _names = struct_get_names(_struct);
    var _count = array_length(_names);
    for (var i = 0; i < _count; i += 1) {
        var _name = _names[i];
        struct_set(_refs.property, _name, ref_create(_refs.ref, _name));
    }
    
    return _refs;
}