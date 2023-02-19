///@param {struct.ServiceContainer} _serviceContainer
///@param {string} _serviceName
function ServiceFactory(_serviceContainer, _serviceName) constructor {
    // Feather disable GM2017
    serviceContainer = _serviceContainer;
    serviceName = _serviceName;
    // Feather restore GM2017

    static create = function() {
       return serviceContainer.get(serviceName);
    }
}