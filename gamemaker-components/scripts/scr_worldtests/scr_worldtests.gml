
tag_script(world_tests, [TAG_UNIT_TEST_SPEC]);
function world_tests() {
    return [
        describe("Worlds - ", function() {
            before_each(function() {
                timeProvider = { 
                    getDeltaSeconds: function(){ return 0.1}
                };
                logger = new LoggingService();
                timeManager = new WorldTimeManager(timeProvider);
                
                testSystem = new ComponentSystem();
                systems = [testSystem];
            });
            after_each(function() {

            });
            describe("Creation: ", function() {
               it("World systems have their systemStart method called.", function() {
                   called = false;
                   testSystem.systemStart = function() { 
                       called = true;
                   };
                   var _world = new World(timeManager, systems, logger);
                   matcher_is_true(called);
               });
            });
            describe("addComponent: ", function() {
               before_each(function() {
                   world = new World(timeManager, systems, logger);
               });
               it("will log a warning if you try and add a component to something that doesnt exist.", function() {
                   called = false;
                   logger.logWarning = function() {
                       called = true; 
                   };
                   logger.logWarning.iAmAnObject = true;
                   world.addComponent("badId", "component");
                   //WOW FUNCTIONS ARE OBJECTS REESE YOU CAN MAKE SPIES
                   //ALSO KEEP TESTING THE WORLDS METHODS
                   matcher_is_true(called);
                   matcher_is_true(logger.logWarning.iAmAnObject);
               });
            });
        })
    ];
}

