serviceContainer = new ServiceContainer();
serviceContainer.service("inputDeviceManager", InputDeviceManager, []);
serviceContainer.service("inputManager", InputManager, ["inputDeviceManager"]);
serviceContainer.service("gameManager", GameManager, ["inputDeviceManager", "inputManager"]);

gameManager = serviceContainer.get("gameManager");