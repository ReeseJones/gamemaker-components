event_inherited();


object_set_size(id, room_width, room_height);
x = room_width / 2;
y = room_height / 2;
depth = 100;
isDraggable = false;
drawDebugOverlay = false;

serviceContainer = global.gameContainer;

vectorPool2d = new EntityPool(function() { return new Vec2()});

inputDeviceManager = serviceContainer.get("inputDeviceManager");
mouseManager = serviceContainer.get("mouseManager");
saveData = serviceContainer.get("gameSaveData");
gameStaticData = serviceContainer.get("gameStaticData");
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
