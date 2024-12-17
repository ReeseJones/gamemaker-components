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

root = flexpanel_create_node({
    name: "obj_game",
    width: "100%",
    height: "100%",
    padding: 32,
    data: id,
    flex: 1,
    flexDirection: "column",
});

prevMouseElement = undefined;
gpu_set_stencil_pass(stencilop_replace);
gpu_set_stencil_fail(stencilop_keep);
guiSurface = -1;
