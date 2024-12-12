event_inherited();

var _layerBlueprint = {
    editorUiLayer: 0,
    instances: 100,
    floorLow: 200,
    corpses: 300,
    background: 400,
}


object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
depth = 100;
isDraggable = false;
drawDebugOverlay = false;

serviceContainer = global.gameContainer;

inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
saveData = serviceContainer.get("gameSaveData");
gameStaticData = serviceContainer.get("gameStaticData");
logger = serviceContainer.get("debugLogger");

layerManager = new LayerManager(_layerBlueprint, logger);

editorUi = undefined;

run_all_specs();

// Moves from bootstrap screen to first room
alarm[0] = 10;


gameStateMode = GAME_STATE_MODE.PLAY;

prevMouseElement = undefined;

gpu_set_stencil_pass(stencilop_replace);
gpu_set_stencil_fail(stencilop_keep);

guiSurface = -1;
particleTypeManager = new ParticleTypeManager();
debugViewManager = new DebugViewManager();
debugViewManager.manageView("Particle Manager", new ParticleManagerEditorGui(debugViewManager, particleTypeManager), false);
enemyManager = new EnemyManager();
cleanupManager = new CleanupManager();
globalParticleManager = new GlobalParticleSystemManager(layerManager);
