tag_script(event_system_tests, [TAG_UNIT_TEST_SPEC]);
function event_system_tests() {
    return [
    describe("EventSystem", function() {
        before_each(function() {
            testKernel = event_system_get_test_kernel();
            gameManager = testKernel.get("gameManager");
            worldOne = gameManager.createWorld(1);
            eventSystem = worldOne.system.event;
            logger = worldOne.logger;
            testSystem = worldOne.system.component;
        });
        after_each(function(){
            worldOne = undefined;
            gameManager.cleanup();
        });

        it("shouldnt crash loading the event system", function() {
            gameManager.updateWorlds();
        });
        
        describe("dispatch", function() {
            describe("should log a warning when", function() {
                before_each(function() {
                    logWarningSpy = spy_on(logger, "logWarning");
                });
                it("an event is queued for the current worldSequence", function() {
                    eventSystem.dispatch("testEventType", 42, "data", worldOne.timeManager.worldSequence);
                    
                    logWarningSpy.toBeCalled();
                });
                it("an event is queued for an old worldSequence", function() {
                    // Set world time to 100
                    worldOne.timeManager.worldSequence = 100;
                    
                    // Dispatch event at world time 4
                    eventSystem.dispatch("testEventType", 42, "data", 4);
                    

                    logWarningSpy.toBeCalled();
                });
            });
            describe("", function() {
                before_each(function() {
                    eventName = "testEventType";
                    callbackSpy = test_spy_create();
                    worldOne.createEntity(42);
                    testSystem.testCallback = callbackSpy.spyMethod;
                    eventSystem.subscribe(1, 42, "component.testCallback", eventName, 42);
                });
                it("should not dispatch an event if the worldSequence is old", function() {
                    worldOne.timeManager.worldSequence = 100;
                
                    eventSystem.dispatch(eventName, 42, "data", 4);
                    worldOne.timeManager.worldSequence = 3;
                    gameManager.updateWorlds();
                
                    callbackSpy.toBeCalledTimes(0);
                });
                it("should dispatch an event on the next world sequence by default", function() {
                    eventSystem.dispatch(eventName, 42, "data");
                    gameManager.updateWorlds();
                
                    callbackSpy.toBeCalledTimes(1);
                });
                it("may dispatch an event on future world sequences", function() {
                    eventSystem.dispatch(eventName, 42, "data", eventSystem.timeManager.worldSequence + 4);
                
                    for(var i = 0; i < 3; i += 1) {
                        gameManager.updateWorlds();
                        callbackSpy.toBeCalledTimes(0);
                    }

                    gameManager.updateWorlds();
                    callbackSpy.toBeCalledTimes(1);
                });
            });
        });
        describe("subscribe", function() {
            describe("should throw when", function() {
                
            });
        });
        describe("systemStep", function() {
            describe("should throw when", function() {
                
            });
        });
        
    })];
}