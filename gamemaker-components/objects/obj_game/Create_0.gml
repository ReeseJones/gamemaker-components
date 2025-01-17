serviceContainer = global.gameContainer;
logger = serviceContainer.get("debugLogger");
commandLineParams = new CommandLineParams(logger);

var _layerBlueprint = {
    editorUiLayer: 0,
    instances: 100,
    floorLow: 200,
    corpses: 300,
    background: 400,
}


x = room_width / 2;
y = room_height / 2;
depth = 100;
drawDebugOverlay = false;

inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
playerSaveData = new PlayerSaveData();
layerManager = new LayerManager(_layerBlueprint, logger);
particleTypeManager = new ParticleTypeManager();
debugViewManager = new DebugViewManager();

cleanupManager = new CleanupManager();
globalParticleManager = new GlobalParticleSystemManager(layerManager);
particleManagerView = undefined;

//run_all_specs();

// Moves from bootstrap screen to first room
alarm[0] = 10;


rootElementStyle = {
    name: "root",
    direction: "ltr",
    position: "relative",
    width: "100%",
    height: "100%",
    flexDirection: "column",
    flexGrow: 1,
    flexShrink: 1,
    padding: 0,
    margin: 0,
};

root = new UIElement(rootElementStyle);

prevMouseElement = undefined;
guiSurface = -1;