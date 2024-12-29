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
saveData = serviceContainer.get("gameSaveData");
gameStaticData = serviceContainer.get("gameStaticData");
layerManager = new LayerManager(_layerBlueprint, logger);
particleTypeManager = new ParticleTypeManager();
debugViewManager = new DebugViewManager();
enemyManager = new EnemyManager();
cleanupManager = new CleanupManager();
globalParticleManager = new GlobalParticleSystemManager(layerManager);
particleManagerView = undefined;

//run_all_specs();

// Moves from bootstrap screen to first room
alarm[0] = 10;


root = new UIElement({
    name: "root",
    direction: "ltr",
    position: "relative",
    width: "100%",
    height: "100%",
    flexDirection: "column",
    flexGrow: 1,
    flexShrink: 1
});

editorUi = make_test_ui()

root.append(editorUi);

prevMouseElement = undefined;
//gpu_set_stencil_pass(stencilop_incr);
//gpu_set_stencil_fail(stencilop_keep);
guiSurface = -1;
debugDrawRelative = true;