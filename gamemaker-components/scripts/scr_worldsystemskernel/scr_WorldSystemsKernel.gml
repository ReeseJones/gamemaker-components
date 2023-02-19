global.gameContainer = new ServiceContainer();
var _gc = global.gameContainer;

_gc.value("gameContainer", global.gameContainer);
_gc.value("worldServiceName", "world");
_gc.service("gameManager", GameManager, ["inputDeviceManager", "inputManager", "worldFactory"]);
_gc.service("inputDeviceManager", InputDeviceManager);
_gc.service("inputManager", InputManager, ["inputDeviceManager"]);
_gc.service("worldFactory", ServiceFactory, ["gameContainer", "worldServiceName"]);


_gc.service("world", World, ["worldTimeManager", "aggregatedSystems"]).inTreeScope();
_gc.service("worldTimeManager", WorldTimeManager, ["realTimeProvider"]).inTreeScope();
_gc.service("entityManager", EntityManager).inTreeScope();
_gc.service("realTimeProvider", TimeProvider);

_gc.service("entityInstanceSystem", EntityInstanceSystem, []).inTreeScope();
_gc.service("entityTreeSystem", EntityTreeSystem, []).inTreeScope();
_gc.service("kinematicMovementSystem", KinematicMovementSystem, []).inTreeScope();
_gc.service("rectangleLayoutSystem", RectangleLayoutSystem, []).inTreeScope();
_gc.service("rectangleSizingSystem", RectangleSizingSystem, []).inTreeScope();
_gc.service("testCompSystem", TestCompSystem, []).inTreeScope();
_gc.service("uiRootSystem", UiRootSystem, []).inTreeScope();

_gc.factory("aggregatedSystems", function() {
    var _systems = [];
    for(var i = 0; i < argument_count; i += 1) {
       array_push(_systems, argument[i]);
    }
    return _systems;
}, [
    "entityTreeSystem",
    "entityInstanceSystem",
    "kinematicMovementSystem",
    "rectangleLayoutSystem",
    "rectangleSizingSystem",
    "testCompSystem",
    "uiRootSystem",
]).inTreeScope();