#macro SERVICE_TYPE_VALUE "value"
#macro SERVICE_TYPE_SERVICE "service"
#macro SERVICE_TYPE_FACTORY "factory"

#macro SERVICE_SCOPE_SINGLETON "singleton"
#macro SERVICE_SCOPE_TRANSIENT "transient"
#macro SERVICE_SCOPE_TREE "tree"

///@func  service(name, value)
///@param {String} _type
///@param {String} _name
///@param {Any} _value
///@param {Array<String>} _dependencies
function ServiceRegistration(_type, _name, _value, _dependencies = [], _scope = SERVICE_SCOPE_SINGLETON) constructor {
    type = _type;
    name = _name;
    value = _value;
    dependencies = _dependencies;
    scope = _scope;
    
    static inSingletonScope = function in_singleton_scope() {
        scope = SERVICE_SCOPE_SINGLETON;
    }
    
    static inTransientScope = function in_transient_scope() {
        scope = SERVICE_SCOPE_TRANSIENT;
    }
    
    static inTreeScope = function in_transient_scope() {
        scope = SERVICE_SCOPE_TREE;
    }
}

function ServiceContainer() constructor {
    // Feather disable GM2017
    valueRegistrationMap = {};
    instanceMap = {};
    treeInstanceMap = {};
    // Feather restore GM2017
    

    ///@func  validateServiceIsUnbound(_name)
    ///@param {String} _name
    static validateServiceIsUnbound = function(_name) {
        if(variable_struct_exists(valueRegistrationMap, _name)) {
            throw "Existing value already bound to " + _name;
        }
    }
    
    ///@func  validateServiceIsUnbound(_name)
    ///@param {Struct.ServiceRegistration} _options
    static bind = function bind(_options) {
         if(is_undefined(_options) || !is_string(_options.name)) {
             throw "Must provide valid options object to bind with valid name";
         }
         validateServiceIsUnbound(_options.name);
          valueRegistrationMap[$ _options.name] = _options;
    }

    ///@func  value(name, value)
    ///@param {String} _name
    ///@param {Any} _value
    ///@returns {Struct.ServiceRegistration}
    static value = function value(_name, _value) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_VALUE, _name, _value);
        return valueRegistrationMap[$ _name];
    }

    ///@func  service(name, constructor, dependencies)
    ///@param {String} _name
    ///@param {Function} _constructor
    ///@param {Array<String>} _dependencies
    ///@returns {Struct.ServiceRegistration}
    static service = function service(_name, _constructor, _dependencies = undefined) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_SERVICE, _name, _constructor, _dependencies);
        return valueRegistrationMap[$ _name];
    }

    ///@func  factory(name, function, dependencies)
    ///@param {String} _name
    ///@param {Function} _function
    ///@param {Array<String>} _dependencies
    ///@returns {Struct.ServiceRegistration}
    static factory = function factory(_name, _function, _dependencies = undefined) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_FACTORY, _name, _function, _dependencies);
        return valueRegistrationMap[$ _name];
    }
    
    ///@func  get(name)
    ///@param {String} _name
    ///@returns {Any}
    static get = function get(_name) {
        delete treeInstanceMap;
        treeInstanceMap = {}
        return getHelper(_name);
    }
    
    ///@func  get(name)
    ///@description Do not use.
    ///@param {String} _name
    ///@returns {Any}
    static getHelper = function(_name) {
       if(variable_struct_exists(instanceMap, _name)) {
            return instanceMap[$ _name];
        }
        if(variable_struct_exists(treeInstanceMap, _name)) {
            return treeInstanceMap[$ _name];
        }
        if(!variable_struct_exists(valueRegistrationMap, _name)) {
            throw "Nothing bound to name: " + _name;
        }
        
        var _serviceRegistration = valueRegistrationMap[$ _name];
        var _serviceInstance = undefined;
        switch(_serviceRegistration.type) {
            case SERVICE_TYPE_VALUE: {
                _serviceInstance = _serviceRegistration.value;
            } break;

            case SERVICE_TYPE_SERVICE: {
                var _deps = array_map(_serviceRegistration.dependencies, function(_depName) {
                    return getHelper(_depName);
                });
                
                _serviceInstance = {};
                var _serviceConstructorStatic = static_get(_serviceRegistration.value);
                //Docs say this doesnt return anything
                // Feather disable once GM2022
                static_set(_serviceInstance, _serviceConstructorStatic);
                method_call(method(_serviceInstance, _serviceRegistration.value), _deps);
            } break;
            
            case SERVICE_TYPE_FACTORY: {
                var _deps = array_map(_serviceRegistration.dependencies, function(_depName) {
                    return getHelper(_depName);
                });
                
                _serviceInstance = method_call(_serviceRegistration.value, _deps);
            } break;
        }

        switch(_serviceRegistration.scope) {
            case SERVICE_SCOPE_SINGLETON:
                instanceMap[$ _name] = _serviceInstance;
                break;
            case SERVICE_SCOPE_TREE:
                treeInstanceMap[$ _name] = _serviceInstance;
                break;
            case SERVICE_SCOPE_TRANSIENT:
                //transient scoped objects never cached, always created
                break;
        }

        return _serviceInstance;
    }
}
