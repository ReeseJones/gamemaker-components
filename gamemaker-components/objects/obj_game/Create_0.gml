//Enable root game object to be an event target.
event_make_event_node_like(id);
serviceContainer = global.gameContainer;
logger = serviceContainer.get("debugLogger");
cmdLineParamRetriever = new CmdLineParamsRetriever();
commandLineParams = new CmdLineParamsParser(logger, cmdLineParamRetriever);
dialog_initialize();


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

run_all_specs();

// Moves from bootstrap screen to first room
alarm[0] = 10;


root = new UIElement();
focus = root;
game_ui_reset_root();

prevMouseElement = undefined;
guiSurface = -1;
