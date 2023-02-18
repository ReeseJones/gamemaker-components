function ServiceFactory(_serviceContainer, _serviceName) constructor {
    serviceContainer = _serviceContainer;
    serviceName = _serviceName;

    static create = function() {
       return serviceContainer.get(serviceName);
    }
}