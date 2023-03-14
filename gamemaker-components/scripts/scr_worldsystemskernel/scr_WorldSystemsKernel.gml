global.gameContainer = new ServiceContainer();
var _gc = global.gameContainer;

_gc.value("gameContainer", global.gameContainer);
_gc.value("worldServiceName", "world");
_gc.service("gameManager", GameManager, ["worldFactory"]);
_gc.service("inputDeviceManager", InputDeviceManager);
_gc.service("inputManager", InputManager, ["inputDeviceManager"]);
_gc.service("worldFactory", ServiceFactory, ["gameContainer", "worldServiceName"]);
_gc.service("debugLogger", LoggingService);

_gc.service("world", World, ["worldTimeManager", "aggregatedSystems", "debugLogger"]).inTreeScope();
_gc.service("worldTimeManager", WorldTimeManager, ["realTimeProvider"]).inTreeScope();
_gc.service("realTimeProvider", TimeProvider);

_gc.service("eventSystem", EventSystem, ["gameManager", "debugLogger", "worldTimeManager"]).inTreeScope();
_gc.service("kinematicMovementSystem", KinematicMovementSystem, []).inTreeScope();
_gc.service("entityInstanceSystem", EntityInstanceSystem, []).inTreeScope();
_gc.service("entityTreeSystem", EntityTreeSystem).inTreeScope();
_gc.service("rectangleLayoutSystem", RectangleLayoutSystem, []).inTreeScope();
_gc.service("rectangleSizingSystem", RectangleSizingSystem, []).inTreeScope();
//_gc.service("testCompSystem", TestCompSystem, []).inTreeScope();
//_gc.service("uiRootSystem", UiRootSystem, []).inTreeScope();

_gc.factory("aggregatedSystems", function() {
    COPY_PARAMS;
    return _params;
}, [
    "eventSystem",
    "entityTreeSystem",
    "entityInstanceSystem",
    "kinematicMovementSystem",
    "rectangleLayoutSystem",
    "rectangleSizingSystem",
    //"testCompSystem",
    //"uiRootSystem",
]).inTreeScope();