
tag_script(world_tests, [TAG_UNIT_TEST_SPEC]);
function world_tests() {
    return [
        describe("Worlds - ", function() {
            before_each(function() {
                timeProvider = { 
                    getDeltaSeconds: function(){ return 0.1}
                };
                
                logger = new LoggingService();
                logWarningSpy = test_spy_create();
                logger.logWarning = logWarningSpy.spyMethod;
                
                timeManager = new WorldTimeManager(timeProvider);
                
                testSystem = new ComponentSystem();
                systemStartSpy = test_spy_create();
                testSystem.systemStart = systemStartSpy.spyMethod;
                //testSystem.addComponent = test_spy_create();
                //testSystem.removeComponent = test_spy_create();
                
                systems = [testSystem];
            });

            describe("Creation: ", function() {
               it("World systems have their systemStart method called.", function() {
                   var _world = new World(timeManager, systems, logger);
                   systemStartSpy.toBeCalled();
                   systemStartSpy.toBeCalledWith();
               });
            });
            describe("addComponent: ", function() {
               before_each(function() {
                   world = new World(timeManager, systems, logger);
               });
               it("will log a warning if you try and add a component to something that doesnt exist.", function() {
                   world.addComponent("badId", "component");
                   logWarningSpy.toBeCalledWith(LOG_LEVEL.IMPORTANT, "Tried to add component '", "component", "' to non existant instance with id: ", "badId");
               });
               it("should add the component", function() {
                   var _newEntity = world.createEntity("tim");
                   world.addComponent("tim", "component");
                   matcher_struct_property_exists(_newEntity.component, "component");
               });
               it("should throw if your try and add a duplicate component", function() {
                   var _newEntity = world.createEntity("tim");
                   world.addComponent("tim", "component");
                   matcher_should_throw( function() {
                        world.addComponent("tim", "component");
                   });
               });
            });
            describe("destroyComponent: ", function() {
               before_each(function() {
                   world = new World(timeManager, systems, logger);
               });
               it("Will log a warning if you try to remove a component from a non existant entity", function() {
                   world.destroyComponent("badId", "component");
                   logWarningSpy.toBeCalled();
               });
               it("should immediately mark the component for descruction", function() {
                   var _newEntity = world.createEntity("tim");
                   var _comp = world.addComponent("tim", "component");
                   matcher_struct_property_exists(_newEntity.component, "component");
                   
                   world.destroyComponent("tim", "component");
                   matcher_is_true(_comp.componentIsDestroyed);
               });
            });
        })
    ];
}

