global.gameContainer = new ServiceContainer();
var _gc = global.gameContainer;

_gc.value("gameContainer", global.gameContainer);

_gc.service("inputDeviceManager", InputDeviceManager);
_gc.service("inputManager", InputManager, ["inputDeviceManager"]);
_gc.service("debugLogger", LoggingService);
_gc.service("mouseManager", MouseManager, ["debugLogger"]);

_gc.service("realTimeProvider", TimeProvider);