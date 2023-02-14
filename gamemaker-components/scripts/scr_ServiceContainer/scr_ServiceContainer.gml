#macro SERVICE_TYPE_VALUE "value"
#macro SERVICE_TYPE_SERVICE "service"
#macro SERVICE_TYPE_FACTORY "factory"

///@func  service(name, value)
///@param {String} _type
///@param {String} _name
///@param {Any} _value
///@param {Array<String>} _dependencies
function ServiceRegistration(_type, _name, _value, _dependencies = []) constructor {
    type = _type;
    name = _name;
    value = _value;
    dependencies = _dependencies;
}

function ServiceContainer() constructor {
    // Feather disable GM2017
    valueRegistrationMap = {};
    instanceMap = {};
    // Feather restore GM2017
    

    ///@func  validateServiceIsUnbound(_name)
    ///@param {String} _name
    static validateServiceIsUnbound = function(_name) {
        if(variable_struct_exists(valueRegistrationMap, _name)) {
            throw "Existing value already bound to " + _name;
        }
    }

    ///@func  value(name, value)
    ///@param {String} _name
    ///@param {Any} _value
    static value = function value(_name, _value) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_VALUE, _name, _value);
    }

    ///@func  service(name, value)
    ///@param {String} _name
    ///@param {Function} _constructor
    ///@param {Array<String>} _dependencies
    static service = function service(_name, _constructor, _dependencies) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_SERVICE, _name, _constructor, _dependencies);
    }

    
    static factory = function factory(_name, _function, _dependencies) {
        validateServiceIsUnbound(_name);
        valueRegistrationMap[$ _name] = new ServiceRegistration(SERVICE_TYPE_FACTORY, _name, _function, _dependencies);
    }
    
    ///@func  get(name)
    ///@param {String} _name
    static get = function get(_name) {
        if(variable_struct_exists(instanceMap, _name)) {
            return instanceMap[$ _name];
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
                    return get(_depName);
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
                    return get(_depName);
                });

                _serviceInstance = method_call(_serviceRegistration.value, _deps);
            } break;
        }

        instanceMap[$ _name] = _serviceInstance;
        return _serviceInstance;
    }
}
