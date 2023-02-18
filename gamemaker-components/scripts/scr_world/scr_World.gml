/// @desc World is the container for all systems which create behavior.
/// @param {Struct.WorldTimeManager} _worldTimeManager Time manager which controls passage of
/// @param {Array<Struct.ComponentSystem>} _systems Time manager which controls passage of
/// time in the world and determines when a new frame starts.
function World(_worldTimeManager, _systems) constructor {
    // Feather disable GM2017
    id = -1;
    timeManager = _worldTimeManager;
    systems = _systems;
    systemCount = array_length(systems);
    // Feather restore GM2017
    
    //assign each system this world.
    array_foreach(systems, function(_system) {
        _system.world = self;
    });
    //run each systems start.
    array_foreach(systems, function(_system) {
        _system.systemStart();
    });

    static cleanup = function cleanup() {
        var _length = array_length(systems);
        for(var i = 0; i < _length; i += 1) {
           systems[i].systemCleanup();
        }
        
        delete timeManager;
        timeManager = undefined;
        systems = undefined;
        systemCount = 0;
        id = undefined;
    }

    static step = function step() {
        var _progressedTimeSequence = timeManager.stepClock();
        if(!_progressedTimeSequence) return;
        
        for(var i = 0; i < systemCount; i += 1) {
            var _system = systems[i];
            if(_system.enabled) {
                _system.systemStep(timeManager.secondsPerTick);
            }
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runBeginStep(timeManager.secondsPerTick);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runStep(timeManager.secondsPerTick);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runEndStep(timeManager.secondsPerTick);
        }
    }

    static draw = function draw() {
        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawBegin(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDraw(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawEnd(timeManager.tickProgress);
        }
    }

    // Feather disable once GM2017
    static drawGui = function draw_gui() {
        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGuiBegin(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGui(timeManager.tickProgress);
        }

        for(var i = 0; i < systemCount; i += 1) {
            systems[i].runDrawGuiEnd(timeManager.tickProgress);
        }
    }
    
    static debugDraw = function debug_draw() {
        var _debugText = [
        "FPS: " + string(fps),
        "Real FPS: " + string(fps_real),
        "World Sequence: " + string(timeManager.worldSequence),
        "Target Ticks Per Second: " + string(timeManager.ticksPerSecond),
        "Seconds Per Tick: " + string(timeManager.secondsPerTick),
        "Last tick: " + string(timeManager.secondsSinceLastTick),
        "Tick Progress: " + string(timeManager.tickProgress),
        "Instance Count: " + string(instance_count)
        ];
        var _printText = array_join(_debugText, "\n");
        draw_text(32, 32, _printText);
    }

    static toString = function to_string() {
        return string_join("WorldID: ", id);
    }
}