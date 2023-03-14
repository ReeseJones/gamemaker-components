///@return {struct.ServiceContainer}
function event_system_get_test_kernel() {
    var _timeProvider = {
        getDeltaSeconds: function() {
            return 0.1;
        }
    };

    var _gc = new ServiceContainer();

    _gc.value("gameContainer", _gc);
    _gc.value("worldServiceName", "world");
    _gc.service("gameManager", GameManager, ["worldFactory"]);
    _gc.service("worldFactory", ServiceFactory, ["gameContainer", "worldServiceName"]);
    _gc.service("debugLogger", LoggingService);

    _gc.service("world", World, ["worldTimeManager", "aggregatedSystems", "debugLogger"]).inTreeScope();
    _gc.service("worldTimeManager", WorldTimeManager, ["fakeTimeProvider"]).inTreeScope();
    _gc.value("fakeTimeProvider", _timeProvider);

    _gc.service("eventSystem", EventSystem, ["gameManager", "debugLogger", "worldTimeManager"]).inTreeScope();
    _gc.service("componentSystem", ComponentSystem, []).inTreeScope();
    
    _gc.factory("aggregatedSystems", function() {
        COPY_PARAMS;
        return _params;
    }, [
        "eventSystem",
        "componentSystem",
    ]).inTreeScope();
    
    return _gc;
}
