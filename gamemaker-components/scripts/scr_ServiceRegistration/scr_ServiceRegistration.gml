///@param {String} _type
///@param {String} _name
///@param {Any} _value
///@param {Array<String>} _dependencies
///@param {String} _scope
function ServiceRegistration(_type, _name, _value, _dependencies = [], _scope = SERVICE_SCOPE_SINGLETON) constructor {
    type = _type;
    name = _name;
    value = _value;
    dependencies = _dependencies;
    scope = _scope;

    static inSingletonScope = function() {
        scope = SERVICE_SCOPE_SINGLETON;
    }

    static inTransientScope = function() {
        scope = SERVICE_SCOPE_TRANSIENT;
    }

    static inTreeScope = function() {
        scope = SERVICE_SCOPE_TREE;
    }
}