enemyManager = new EnemyManager();

instanceLayer = obj_game.layerManager.getLayer("instances");
playerSaveData = obj_game.playerSaveData;
currentDay = playerSaveData.gameDay;

player = undefined;
camera = undefined;

setupTimer = 0;

elapsedFightTime = 0;

maxFightLength = 80;

spawnTimer = 0;

spawnRate = 1 / (1 + currentDay);



stateArenaStart = function (_dt) {
    player = instance_create_layer(room_width / 2, room_height / 2, instanceLayer, obj_player_base);
    camera = instance_create_layer(room_width / 2, room_height / 2, instanceLayer, obj_camera);
    enemyManager.enemyTarget = player;
    
    show_debug_message("Created arena");
    currentStateMethod = stateSetupTime;
};

stateSetupTime = function (_dt) {
    setupTimer += _dt;
    
    if(setupTimer > 10) {
        currentStateMethod = stateFightTime;
        show_debug_message("Starting arena fight...");
    }
};

stateFightTime = function (_dt) {
    elapsedFightTime += _dt;
    var _fightDt = elapsedFightTime / maxFightLength;
    var _diff = difficulty_curve(_fightDt);
    spawnTimer += _dt;
    spawnRate = 1 / ( (1 + currentDay) * _diff * 2);
    
    
    if(spawnTimer > spawnRate) {
        spawnTimer = 0;
        enemyManager.createEnemies()
        
    }
    
    enemyManager.step();
    
    if(_fightDt >= 1) {
        setupTimer = 0;
        currentStateMethod = stateEndOfFight;
        show_debug_message("Arena fight ended");
    }
};

stateEndOfFight = function(_dt) {
    setupTimer += _dt;
    
    if(setupTimer > 5) {
        show_debug_message("Going back to main menu");
        room_goto(rm_main_menu);
    }
};


currentStateMethod = stateArenaStart;